#import "ACMSignUpViewController.h"
#import <Cloudmine/CloudMine.h>

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)nextButtonDidPress:(UIBarButtonItem *)sender
{
    CMUser *newUser = [[CMUser alloc] initWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text];

    [newUser createAccountAndLoginWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {

        if (CMUserAccountOperationFailed(resultCode)) {
            NSLog(@"Account Creation Failed with code: %ld\nMessages: %@", (long)resultCode, messages);
            return;
        }

        NSLog(@"Account creation succeeded with code: %ld\nMessages: %@", (long)resultCode, messages);
    }];
}

#pragma mark Notifications

- (void)handleTextChange
{
    self.nextButton.enabled = self.isValidInput;
}

#pragma mark Private Helpers

- (BOOL)isValidInput
{
    return self.enteredValidEmail && self.enteredValidPassword;
}

- (BOOL)enteredValidEmail
{
    // TODO: real email validation
    return nil != self.emailTextField.text && self.emailTextField.text.length > 3;
}

- (BOOL)enteredValidPassword
{
    // TODO: real password validation
    return nil != self.passwordTextField.text && self.passwordTextField.text.length > 5;
}

@end
