#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"
#import "ORKResult+CloudMine.h"
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

    self.oncePieChart.title = NSLocalizedString(@"One Time Surveys Completed", nil);
    self.oncePieChart.showsTitleAboveChart = YES;

    self.dailyPieChart.title = NSLocalizedString(@"Daily Surveys Completed Today", nil);
    self.dailyPieChart.showsTitleAboveChart = YES;

    __weak typeof(self) weakSelf = self;
    [NSNotificationCenter.defaultCenter addObserverForName:ACMSurveyDataNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf refreshUI];
    }];

    [self refreshUI];
}

- (void)refreshUI
{
    self.aboutYouCount = [self.acm_mainPanel countOfSurveyResultsWithIdentifier:@"ACMAboutYouSurveyTask"];
    self.dailyCount = [self.acm_mainPanel countOfSurveyResultsWithIdentifier:@"" onCalendarDay:[NSDate new]];

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
    if (self.aboutYouCount > 0) {
        return NSLocalizedString(@"Complete", nil);
    }

    return NSLocalizedString(@"Incomplete", nil);
}

- (UIColor *)pieChartView:(ORKPieChartView *)pieChartView colorForSegmentAtIndex:(NSInteger)index
{
    if (self.aboutYouCount > 0) {
        return [UIColor acmOnceColor];
    } else {
        return [UIColor redColor];
    }
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
