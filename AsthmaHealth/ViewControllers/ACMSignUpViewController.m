#import "ACMSignUpViewController.h"
#import "ACMAppDelegate.h"
#import "ACMUserController.h"

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
    [ACMUserController.currentUser signUpWithEmail:self.emailTextField.text
                                          password:self.passwordTextField.text
                                        andConsent:self.consentResults
                                    withCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            NSLog(@"Account Creation Failed: %@", error.localizedDescription);
            return;
        }

        NSLog(@"Account Created Successfully");

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appDelegate loadMainPanel];
        });
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

- (ACMAppDelegate *)appDelegate
{
    if (![[UIApplication sharedApplication].delegate isKindOfClass:[ACMAppDelegate class]]) {
        return nil;
    }

    return [UIApplication sharedApplication].delegate;
}

@end
