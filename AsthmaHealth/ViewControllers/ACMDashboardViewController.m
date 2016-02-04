#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"
#import "ORKResult+CloudMine.h"

@interface ACMDashboardViewController ()

@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [ORKTaskResult cm_fetchUserResultsWithCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
        NSLog(@"Results: %@", results);
    }];
}

@end
