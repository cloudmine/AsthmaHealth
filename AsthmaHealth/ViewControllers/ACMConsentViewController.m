#import "ACMConsentViewController.h"
#import "ACMConsentTask.h"

@interface ACMConsentViewController ()

@end

@implementation ACMConsentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    self.showsProgressInNavigationBar = NO;
    self.task = ACMConsentTask.task;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
