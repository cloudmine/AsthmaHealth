#import "ACMProfileViewController.h"
#import "ACMUserController.h"
#import "ACMUserData.h"
#import "ACMAppDelegate.h"

@interface ACMProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation ACMProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureWithUserData:[ACMUserController currentUser].userData];

    self.logoutButton.layer.borderColor = self.logoutButton.titleLabel.textColor.CGColor;
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.cornerRadius = 4.0f;
}

- (void)configureWithUserData:(ACMUserData *)userData
{
    self.emailLabel.text = userData.email;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", userData.givenName, userData.familyName];
}

#pragma mark Target-Action

- (IBAction)logoutButtonDidPress:(UIButton *)sender
{
    [self presentViewController:self.logoutConfirmationAlert animated:YES completion:nil];
}

#pragma mark Private
- (UIAlertController *)logoutConfirmationAlert
{
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Log Out", nil)
                                                                               message:NSLocalizedString(@"Are you sure you want to log out?", nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Log Out", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        [self logUserOut];
    }];

    [confirmationAlert addAction:cancelAction];
    [confirmationAlert addAction:confirmAction];

    return confirmationAlert;
}

- (void)logUserOut
{
    [[ACMUserController currentUser] logoutWithCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ACMProfileViewController modalAlertWithMessage:error.localizedDescription]
                                   animated:YES
                                 completion:nil];
            });

            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appDelegate loadOnboarding];
        });
    }];
}

+ (UIAlertController *)modalAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) { }]];
    return alert;
}

- (ACMAppDelegate *)appDelegate
{
    if (![[UIApplication sharedApplication].delegate isKindOfClass:[ACMAppDelegate class]]) {
        return nil;
    }

    return (ACMAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
