#import <ResearchKit/ResearchKit.h>

@interface ACMSurveyFactory : NSObject

+ (ORKTaskViewController *_Nullable)surveyViewControllerForIdentifier:(NSString *_Nullable)surveyIdentifier;

@end
