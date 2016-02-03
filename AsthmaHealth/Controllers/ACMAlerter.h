#import <UIKit/UIKit.h>

@interface ACMAlerter : NSObject

+ (void)displayAlertWithTitle:(NSString *_Nullable)title
                   andMessage:(NSString *_Nonnull)message
             inViewController:(UIViewController *_Nonnull)viewController;

@end
