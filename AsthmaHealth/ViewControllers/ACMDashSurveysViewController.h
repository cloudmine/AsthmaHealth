#import <UIKit/UIKit.h>
#import <ResearchKit/ResearchKit.h>

@interface ACMDashSurveysViewController : UITableViewController
@property (nonatomic, nullable) NSArray<ORKTaskResult *> *surveyResults;
@end
