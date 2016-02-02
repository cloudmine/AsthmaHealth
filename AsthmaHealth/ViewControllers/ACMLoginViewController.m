#import "ACMLoginViewController.h"
#import "ACMValidators.h"

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
        NSLog(@"%@", invalidEmailMessage);
    }
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
    // TODO: real email validation
    return nil != self.emailTextField.text && self.emailTextField.text.length > 3;
}

- (BOOL)hasEnteredPasswordText
{
    // TODO: real password validation
    return nil != self.passwordTextField.text && self.passwordTextField.text.length > 5;
}

@end
