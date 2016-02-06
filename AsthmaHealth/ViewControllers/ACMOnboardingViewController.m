#import "ACMOnboardingViewController.h"
#import "ACMConsentViewController.h"
#import "ACMSignUpViewController.h"

static NSString *const ACMSignUpSegueIdentifier = @"ACMSignUpSegue";

@interface ACMOnboardingViewController () <ORKTaskViewControllerDelegate>

@property (nonatomic, nullable) ORKTaskResult* consentResults;
@property (weak, nonatomic) IBOutlet UIButton *joinStudyButton;

@end

@implementation ACMOnboardingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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

#pragma mark Private Helprs

- (void)handleConsentCompleted
{
    NSAssert([self.presentedViewController isKindOfClass:[ACMConsentViewController class]],
             @"Attempted -handleConsentCompletd when a ACMConsentViewController was not presented");

    self.consentResults = ((ACMConsentViewController *)self.presentedViewController).result;

    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:ACMSignUpSegueIdentifier sender:self];
}

- (void)removeNavigationBarDropShadow
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];

}

@end
