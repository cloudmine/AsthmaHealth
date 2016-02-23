#import "ACMOnboardingViewController.h"
#import "ACMConsentViewController.h"
#import "ACMSignUpViewController.h"
#import "ACMalerter.h"
#import "ACMAppDelegate.h"

static NSString *const ACMSignUpSegueIdentifier = @"ACMSignUpSegue";

@interface ACMOnboardingViewController () <ORKTaskViewControllerDelegate, CMHSignupViewDelegate>

@property (nonatomic, nullable) ORKTaskResult* consentResults;
@property (weak, nonatomic) IBOutlet UIButton *joinStudyButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ACMOnboardingViewController

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
    } else if ([segue.destinationViewController isKindOfClass:[ACMSignUpViewController class]] && nil != self.consentResults) {
        ACMSignUpViewController * signupVC = (ACMSignUpViewController *)segue.destinationViewController;
        signupVC.consentResults = self.consentResults;
    }
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

    self.consentResults = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark CMHSignupViewDelegate

- (void)signupViewDidCancel
{
    if (![self.presentedViewController isKindOfClass:[CMHSignupViewController class]]) {
        return;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signupViewDidCompleteWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [self.activityIndicator startAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];

    [CMHUser.currentUser signUpWithEmail:email password:password andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Sign up Failed", nil)
                                       andMessage:error.localizedDescription
                                 inViewController:self];
            });
            return;
        }

        [CMHUser.currentUser uploadUserConsent:self.consentResults forStudyWithDescriptor:@"ACMHealth" andCompletion:^(NSError * _Nullable consentError) {
            if (nil != consentError) {
                dispatch_async(dispatch_get_main_queue(), ^{
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

#pragma mark Private Helprs

- (void)handleConsentCompleted
{
    NSAssert([self.presentedViewController isKindOfClass:[ACMConsentViewController class]],
             @"Attempted -handleConsentCompletd when a ACMConsentViewController was not presented");

    self.consentResults = ((ACMConsentViewController *)self.presentedViewController).result;

    [self dismissViewControllerAnimated:YES completion:nil];

    CMHSignupViewController *signupViewController = [CMHSignupViewController signupViewController];
    signupViewController.delegate = self;

    [self presentViewController:signupViewController animated:YES completion:nil];
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

    return [UIApplication sharedApplication].delegate;
}

@end
