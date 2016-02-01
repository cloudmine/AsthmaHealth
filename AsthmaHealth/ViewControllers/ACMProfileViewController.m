#import "ACMProfileViewController.h"
#import "ACMUserController.h"
#import "ACMUserData.h"

@interface ACMProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ACMProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureWithUserDat:[ACMUserController currentUser].userData];
}

- (void)configureWithUserDat:(ACMUserData *)userData
{
    self.emailLabel.text = userData.email;
}

- (IBAction)logoutButtonDidPress:(UIButton *)sender
{
    NSLog(@"Logout");
}

@end
