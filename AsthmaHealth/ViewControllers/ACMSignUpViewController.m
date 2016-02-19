#import "ACMSignUpViewController.h"
#import <CMHealth/CMHealth.h>
#import "ACMAppDelegate.h"
#import "ACMValidators.h"
#import "ACMAlerter.h"

@interface ACMSignUpViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, readonly) BOOL isValidInput;

@end

@implementation ACMSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nextButton.enabled = self.isValidInput;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self restoreNavigationBarDropShadow];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)nextButtonDidPress:(UIBarButtonItem *)sender
{
    NSString *invalidEmailMessage = [ACMValidators localizedValidationErrorMessageForEmail:self.emailTextField.text];

    if (nil != invalidEmailMessage) {
        [ACMAlerter displayAlertWithTitle:nil andMessage:invalidEmailMessage inViewController:self];
        return;
    }

    [CMHUser.currentUser signUpWithEmail:self.emailTextField.text password:self.passwordTextField.text andCompletion:^(NSError * _Nullable error) {
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

#pragma mark Notifications

- (void)handleTextChange
{
    self.nextButton.enabled = self.hasEnteredInputs;
}

#pragma mark Private Helpers

- (BOOL)hasEnteredInputs
{
    return self.hasEnteredEmailText && self.hasEnteredPasswordText;
}

- (BOOL)hasEnteredEmailText
{
    return nil != self.emailTextField.text && self.emailTextField.text.length > 4;
}

- (BOOL)hasEnteredPasswordText
{
    return nil != self.passwordTextField.text && self.passwordTextField.text.length > 5;
}

- (ACMAppDelegate *)appDelegate
{
    if (![[UIApplication sharedApplication].delegate isKindOfClass:[ACMAppDelegate class]]) {
        return nil;
    }

    return [UIApplication sharedApplication].delegate;
}

- (void)restoreNavigationBarDropShadow
{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:nil
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:nil];
}

@end
