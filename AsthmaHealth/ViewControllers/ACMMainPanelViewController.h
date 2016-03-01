#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

static NSString *_Nullable const ACMSurveyDataNotification = @"ACMSurveyDataFetched";

@interface ACMMainPanelViewController : UITabBarController

@property (nonatomic, nullable, readonly) ORKTaskResult *todaysDailySurveyResult;
@property (nonatomic, nullable, readonly) ORKTaskResult *aboutYouSurveyResult;

- (void)refreshData;
- (void)uploadResult:(ORKResult *_Nonnull)surveyResult;

@end
