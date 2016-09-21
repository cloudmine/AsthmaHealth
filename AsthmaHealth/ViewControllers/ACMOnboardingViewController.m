#import "ACMOnboardingViewController.h"
#import "ACMConsentViewController.h"
#import "ACMalerter.h"
#import "ACMAppDelegate.h"
#import "UIColor+ACM.h"

static NSString *const ACMSignUpSegueIdentifier = @"ACMSignUpSegue";

@interface ACMOnboardingViewController () <ORKTaskViewControllerDelegate, CMHLoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *joinStudyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ACMOnboardingViewController

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.activityIndicator stopAnimating];

    self.joinStudyButton.layer.borderColor = self.joinStudyButton.titleLabel.textColor.CGColor;
    self.joinStudyButton.layer.borderWidth = 1.0f;
    self.joinStudyButton.layer.cornerRadius = 4.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removeNavigationBarDropShadow];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ACMConsentViewController class]]) {
        ACMConsentViewController *consentVC = (ACMConsentViewController *)segue.destinationViewController;
        consentVC.delegate = self;
    }
}

#pragma mark Target/Action

- (IBAction)loginButtonDidPress:(UIButton *)sender
{
    CMHLoginViewController *loginVC = [[CMHLoginViewController alloc] initWithTitle:NSLocalizedString(@"Log In", nil)
                                                                               text:NSLocalizedString(@"Please log in to you account to store and access your research data.", nil)
                                                                           delegate:self];
    loginVC.view.tintColor = [UIColor acmBlueColor];

    [self presentViewController:loginVC animated:YES completion:nil];
}


#pragma mark ORKTaskViewControllerDelegate

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
    if (nil != error) {
        NSLog(@"Consent Error: %@", error.localizedDescription);
        return;
    }

    switch (reason) {
        case ORKTaskViewControllerFinishReasonCompleted:
            [self handleConsentCompleted];
            return;
        case ORKTaskViewControllerFinishReasonDiscarded:
            NSLog(@"Consent Discarded");
            break;
        case ORKTaskViewControllerFinishReasonFailed:
            NSLog(@"Consent Failed");
            break;
        case ORKTaskViewControllerFinishReasonSaved:
            NSLog(@"Consent Saved");
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CMHLoginViewControllerDelegate

- (void)loginViewControllerCancelled:(CMHLoginViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginViewController:(CMHLoginViewController *)viewController didLogin:(BOOL)success error:(NSError *)error
{
    if (!success) {
        [self.activityIndicator stopAnimating];
        [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Sign In Failure", nil)
                               andMessage:[NSString localizedStringWithFormat:@"Sign in failed, please try again. %@", error.localizedDescription]
                         inViewController:viewController];
        return;
    }

    [self.appDelegate loadMainPanel];
}

#pragma mark Private Helpers

- (void)handleConsentCompleted
{
    NSAssert([self.presentedViewController isKindOfClass:[ACMConsentViewController class]],
             @"Attempted -handleConsentCompletd when a ACMConsentViewController was not presented");

    ORKTaskResult *onboardingResults = ((ACMConsentViewController *)self.presentedViewController).result;

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self signupWithOnboardingResults:onboardingResults];
}

- (void)signupWithOnboardingResults:(ORKTaskResult *)results
{
    [CMHUser.currentUser signUpWithRegistration:results andCompletion:^(NSError * _Nullable signupError) {
        if (nil != signupError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Sign up Failed", nil)
                                       andMessage:signupError.localizedDescription
                                 inViewController:self];
            });
            return;
        }

        [CMHUser.currentUser uploadUserConsent:results forStudyWithDescriptor:@"ACMHealth" andCompletion:^(CMHConsent * _Nullable consent, NSError * _Nullable consentError) {
            if (nil != consentError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.activityIndicator stopAnimating];
                    [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Saving Consent Failed", nil)
                                           andMessage:consentError.localizedDescription
                                     inViewController:self];
                });
                return;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.appDelegate loadMainPanel];
            });
        }];
    }];
}

- (void)removeNavigationBarDropShadow
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];

}

- (ACMAppDelegate *)appDelegate
{
    if (![[UIApplication sharedApplication].delegate isKindOfClass:[ACMAppDelegate class]]) {
        return nil;
    }

    return (ACMAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
