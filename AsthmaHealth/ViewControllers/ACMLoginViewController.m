#import "ACMLoginViewController.h"
#import "ACMValidators.h"
#import "ACMAlerter.h"

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

@end
