#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import <CMHealth/CMHealth.h>
#import "ACMMainPanelViewController.h"
#import "UIViewController+ACM.h"
#import "UIColor+ACM.h"

@interface ACMDashboardViewController ()<ORKPieChartViewDataSource>
@property (weak, nonatomic) IBOutlet ORKPieChartView *oncePieChart;
@property (weak, nonatomic) IBOutlet ORKPieChartView *dailyPieChart;

@property (nonatomic) NSInteger aboutYouCount;
@property (nonatomic) NSInteger dailyCount;
@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.oncePieChart.title = NSLocalizedString(@"One Time Surveys", nil);
    self.oncePieChart.showsTitleAboveChart = YES;

    self.dailyPieChart.title = NSLocalizedString(@"Daily Surveys (Today)", nil);
    self.dailyPieChart.showsTitleAboveChart = YES;

    __weak typeof(self) weakSelf = self;
    [NSNotificationCenter.defaultCenter addObserverForName:ACMSurveyDataNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf refreshUI];
    }];

    [self refreshUI];
}

- (void)refreshUI
{
    self.aboutYouCount = nil == self.acm_mainPanel.aboutYouSurveyResult ? 0 : 1;
    self.dailyCount = nil == self.acm_mainPanel.todaysDailySurveyResult ? 0 : 1;

    dispatch_async(dispatch_get_main_queue(), ^{
        // Setting the data source property forces the data to reload
        self.oncePieChart.dataSource = self;
        self.dailyPieChart.dataSource = self;
    });
}

- (IBAction)refreshButtonDidPress:(UIButton *)sender
{
    [self.acm_mainPanel refreshData];
}

#pragma mark ORKPieChartViewDataSource
- (NSInteger)numberOfSegmentsInPieChartView:(ORKPieChartView *)pieChartView
{
    return 1;
}

- (CGFloat)pieChartView:(ORKPieChartView *)pieChartView valueForSegmentAtIndex:(NSInteger)index
{
   return 1.0f;
}

- (NSString *)pieChartView:(ORKPieChartView *)pieChartView titleForSegmentAtIndex:(NSInteger)index
{
    if ((pieChartView == self.oncePieChart && self.aboutYouCount > 0) ||
        (pieChartView == self.dailyPieChart && self.dailyCount > 0) ) {
        return NSLocalizedString(@"Complete", nil);
    }

    return NSLocalizedString(@"Incomplete", nil);
}

- (UIColor *)pieChartView:(ORKPieChartView *)pieChartView colorForSegmentAtIndex:(NSInteger)index
{
    if (pieChartView == self.oncePieChart && self.aboutYouCount > 0) {
        return [UIColor acmOnceColor];
    } else if(pieChartView == self.dailyPieChart && self.dailyCount > 0) {
        return [UIColor acmDailyColor];
    }

    return [UIColor redColor];
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
