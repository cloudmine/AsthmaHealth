#import "ACMProfileViewController.h"
#import <CMHealth/CMHealth.h>
#import "ACMAppDelegate.h"
#import "ACMAlerter.h"

@interface ACMProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *learnButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (nonatomic) MFMailComposeViewController *mailViewController;
@end

@implementation ACMProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configureWithUserData:[CMHUser currentUser].userData];
    [ACMProfileViewController styleButtons:@[self.logoutButton]];

    self.mailViewController = [ACMProfileViewController mailComposeViewControllerWithDelegate:self];
}

- (void)configureWithUserData:(CMHUserData *)userData
{
    self.emailLabel.text = userData.email;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", userData.givenName, userData.familyName];
}

#pragma mark Target-Action

- (IBAction)logoutButtonDidPress:(UIButton *)sender
{
    [self presentViewController:self.logoutConfirmationAlert animated:YES completion:nil];
}

- (IBAction)learnButtonDidPress:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://cloudmineinc.com"]];
}

- (IBAction)emailButtonDidPress:(id)sender
{
    if (nil == self.mailViewController) {
        [ACMAlerter displayAlertWithTitle:nil
                               andMessage:NSLocalizedString(@"The mail app is not configured on your device.", nil)
                         inViewController:self];

        return;
    }

    [self presentViewController:self.mailViewController animated:YES completion:nil];
}
     
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [[CMHUser currentUser] logoutWithCompletion:^(NSError * _Nullable error) {
        if (nil != error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ACMAlerter displayAlertWithTitle:nil andMessage:error.localizedDescription inViewController:self];
            });

            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appDelegate loadOnboarding];
        });
    }];
}

+ (MFMailComposeViewController *)mailComposeViewControllerWithDelegate:(id<MFMailComposeViewControllerDelegate>)delegate
{
    if (![MFMailComposeViewController canSendMail]) {
        return nil;
    }

    MFMailComposeViewController* composeVC = [MFMailComposeViewController new];
    composeVC.mailComposeDelegate = delegate;
    [composeVC setToRecipients:@[@"sales@cloudmineinc.com"]];
    [composeVC setSubject:@"CHC inquiry - AsthmaHealth"];
    [composeVC setMessageBody:@"I would like to learn more about ResearchKit and the CloudMine Connected Health Cloud." isHTML:NO];

    return composeVC;
}

+ (void)styleButtons:(NSArray<UIButton *> *)buttons
{
    for (UIButton *aButton in buttons) {
        aButton.layer.borderColor = aButton.titleLabel.textColor.CGColor;
        aButton.layer.borderWidth = 1.0f;
        aButton.layer.cornerRadius = 4.0f;
    }
}

- (ACMAppDelegate *)appDelegate
{
    if (![[UIApplication sharedApplication].delegate isKindOfClass:[ACMAppDelegate class]]) {
        return nil;
    }

    return (ACMAppDelegate *)[UIApplication sharedApplication].delegate;
}

@end
