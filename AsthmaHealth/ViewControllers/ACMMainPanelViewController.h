#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

static NSString *_Nullable const ACMSurveyDataNotification = @"ACMSurveyDataFetched";

@interface ACMMainPanelViewController : UITabBarController

@property (nonatomic, nullable, readonly) ORKTaskResult *consentResult;
@property (nonatomic, nullable, readonly) NSArray <ORKTaskResult *> *surveyResults;

- (void)refreshData;
- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier;

@end
