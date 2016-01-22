#import "ACMOnboardingViewController.h"
#import "ACMConsentViewController.h"
#import "ACMSignUpViewController.h"

static NSString *const ACMSignUpSegueIdentifier = @"ACMSignUpSegue";

@interface ACMOnboardingViewController () <ORKTaskViewControllerDelegate>

@property (nonatomic, nullable) ORKTaskResult* consentResults;

@end

@implementation ACMOnboardingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Remove navigation bar drop shadow
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
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
    NSAssert([self.presentedViewController isKindOfClass:[ACMConsentViewController class]], @"Handle Consent Completion");

    self.consentResults = ((ACMConsentViewController *)self.presentedViewController).result;

    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:ACMSignUpSegueIdentifier sender:self];
}

@end
