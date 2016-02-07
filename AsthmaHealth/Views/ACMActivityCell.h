#import <UIKit/UIKit.h>

@class ACMSurveyMetaData;

@interface ACMActivityCell : UITableViewCell

- (void)configureWithMetaData:(ACMSurveyMetaData *_Nonnull)metaData;

@end
