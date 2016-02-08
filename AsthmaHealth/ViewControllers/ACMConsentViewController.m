#import "ACMConsentViewController.h"
#import "ACMConsentTask.h"
#import "UIColor+ACM.h"

@interface ACMConsentViewController ()

@end

@implementation ACMConsentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    self.showsProgressInNavigationBar = NO;
    self.view.tintColor = [UIColor acmBlueColor];
    self.task = ACMConsentTask.task;

    return self;
}

@end
