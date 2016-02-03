#import "ACMLoginViewController.h"
#import "ACMValidators.h"
#import "ACMAlerter.h"
#import "ACMUserController.h"
#import "ACMAppDelegate.h"

@interface ACMLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation ACMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.doneButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Target-Action
- (IBAction)doneButtonDidPress:(UIBarButtonItem *)sender
{
    NSString *invalidEmailMessage = [ACMValidators localizedValidationErrorMessageForEmail:self.emailTextField.text];

    if (nil != invalidEmailMessage) {
        [ACMAlerter displayAlertWithTitle:nil andMessage:invalidEmailMessage inViewController:self];
        return;
    }

    [ACMUserController.currentUser loginWithEmail:self.emailTextField.text password:self.passwordTextField.text andCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Sign In Failure", nil)
                                       andMessage:[NSString localizedStringWithFormat:@"Sign in failed, please try again. %@", error.localizedDescription]
                                 inViewController:self];
            });
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appDelegate loadMainPanel];
        });
    }];
}

#pragma mark Notifications

- (void)handleTextChange
{
    self.doneButton.enabled = self.hasEnteredInputs;
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

@end
