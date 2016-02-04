#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"

@interface ACMDashboardViewController ()

@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[CMStore defaultStore] allUserObjectsOfClass:[ACMResultWrapper wrapperClassForResultClass:[ORKTaskResult class]]
                                additionalOptions:nil
                                         callback:^(CMObjectFetchResponse *response)
    {
        ORKTaskResult *firstResult = [response.objects.firstObject performSelector:@selector(wrappedResult)];
        NSLog(@"First Result: %@", firstResult);
    }];
}

@end
