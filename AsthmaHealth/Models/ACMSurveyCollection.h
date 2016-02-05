#import <Foundation/Foundation.h>

@class ACMSurveyMetaData;

@interface ACMSurveyCollection : NSObject

@property (nonatomic, readonly) NSInteger count;

- (ACMSurveyMetaData *_Nonnull)metaDataForSurveyAtIndex:(NSInteger)index;

@end
