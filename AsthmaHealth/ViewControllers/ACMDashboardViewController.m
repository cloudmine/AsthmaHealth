#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"
#import "ORKResult+CloudMine.h"
#import "ACMMainPanelViewController.h"
#import "UIViewController+ACM.h"

@interface ACMDashboardViewController ()<ORKPieChartViewDataSource>
@property (weak, nonatomic) IBOutlet ORKPieChartView *oncePieChart;
@property (nonatomic) NSInteger value;
@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    [NSNotificationCenter.defaultCenter addObserverForName:ACMSurveyDataNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf refreshUI];
    }];

    self.value = 1;

    [self refreshUI];
}

- (void)refreshUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.oncePieChart.dataSource = self;
        self.value += 1;
    });
}

- (IBAction)refreshButtonDidPress:(UIButton *)sender
{
    [self.acm_mainPanel refreshData];
}

#pragma mark ORKPieChartViewDataSource
- (NSInteger)numberOfSegmentsInPieChartView:(ORKPieChartView *)pieChartView
{
    return 2;
}

- (CGFloat)pieChartView:(ORKPieChartView *)pieChartView valueForSegmentAtIndex:(NSInteger)index
{
    return self.value + index % 2;
}

// TODO: Move this to profile?
//#pragma mark Presentation
//+ (NSString *_Nonnull)consentDateStringForDate:(NSDate *_Nullable)date
//{
//    if (nil == date) {
//        return @"Never";
//    }
//
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.dateFormat = @"MMM dd, yyyy";
//
//    return [formatter stringFromDate:date];
//}

@end
