#import "ACMLoginViewController.h"

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
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark Notifications

- (void)handleTextChange
{
    self.doneButton.enabled = self.isValidInput;
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
