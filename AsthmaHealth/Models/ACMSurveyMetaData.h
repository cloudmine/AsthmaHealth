#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ACMSurveyFrequency) {
    ACMSurveyFrequencyOnce = 0,
    ACMSurveyFrequencyDaily
};

@interface ACMSurveyMetaData : NSObject

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name
                           identifier:(NSString *_Nonnull)identifier
                            frequency:(ACMSurveyFrequency)frequency
                     andQuestionCount:(NSNumber *_Nonnull)qCount;

@property (nonatomic, nonnull, readonly) NSString *displayName;
@property (nonatomic, nonnull, readonly) NSString *rkIdentifier;
@property (nonatomic, nonnull, readonly) NSNumber *questionCount;
@property (nonatomic, readonly) ACMSurveyFrequency frequency;

@end
