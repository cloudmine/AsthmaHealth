#import "UIViewController+ACM.h"
#import "ACMMainPanelViewController.h"

@implementation UIViewController (ACM)

- (ACMMainPanelViewController *)acm_mainPanel
{
    for (UIViewController *pVC = self.parentViewController; nil != pVC; pVC = pVC.parentViewController) {
        if ([pVC isKindOfClass:[ACMMainPanelViewController class]]) {
            return (ACMMainPanelViewController *)pVC;
        }
    }

    return nil;
}

@end
