#import "ACMAlerter.h"

@implementation ACMAlerter

+ (void)displayAlertWithTitle:(NSString *_Nullable)title
                   andMessage:(NSString *_Nonnull)message
             inViewController:(UIViewController *_Nonnull)viewController
{
    NSAssert(nil != message, @"ACMAlertFactory: Attempted to display an alert with nil message");
    NSAssert(nil != viewController, @"ACMAlertFactory: Attempted to display an alert in a nil view controller");

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
    [alert addAction:okAction];

    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
