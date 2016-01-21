#import "ACMSignUpViewController.h"

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
