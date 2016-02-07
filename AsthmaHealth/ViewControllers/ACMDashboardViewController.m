#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"
#import "ORKResult+CloudMine.h"
#import "ACMDashSurveysViewController.h"
#import "ACMMainPanelViewController.h"
#import "UIViewController+ACM.h"

@interface ACMDashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *consentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *surveyCountLabel;
@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NSNotificationCenter.defaultCenter addObserverForName:ACMSurveyDataNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self refreshUI];
    }];

    [self refreshUI];
}

- (void)refreshUI
{
    NSString *consentDate = [ACMDashboardViewController consentDateStringForDate:self.acm_mainPanel.consentResult.endDate];
    NSString *surveyCount = [NSString stringWithFormat:@"%li", (long)self.acm_mainPanel.surveyResults.count];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.consentDateLabel.text = consentDate;
        self.surveyCountLabel.text = surveyCount;
    });
}

- (IBAction)refreshButtonDidPress:(UIButton *)sender
{
    [self.acm_mainPanel refreshData];
}

#pragma mark Presentation
+ (NSString *_Nonnull)consentDateStringForDate:(NSDate *_Nullable)date
{
    if (nil == date) {
        return @"Never";
    }

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM dd, yyyy";

    return [formatter stringFromDate:date];
}

@end
