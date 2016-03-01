#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

static NSString *_Nullable const ACMSurveyDataNotification = @"ACMSurveyDataFetched";

@interface ACMMainPanelViewController : UITabBarController

@property (nonatomic, nullable, readonly) NSArray <ORKTaskResult *> *surveyResults;

- (void)refreshData;
- (void)uploadResult:(ORKResult *_Nonnull)surveyResult;

- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier;
- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier onCalendarDay:(NSDate *_Nonnull)day;

@end
