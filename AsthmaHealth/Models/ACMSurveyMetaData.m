#import "ACMSurveyMetaData.h"

@interface ACMSurveyMetaData ()
@property (nonatomic, nonnull, readwrite) NSString *displayName;
@property (nonatomic, nonnull, readwrite) NSString *rkIdentifier;
@property (nonatomic, nonnull, readwrite) NSNumber *questionCount;
@property (nonatomic, readwrite) ACMSurveyFrequency frequency;
@end

@implementation ACMSurveyMetaData

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name identifier:(NSString *_Nonnull)identifier frequency:(ACMSurveyFrequency)frequency andQuestionCount:(NSNumber * _Nonnull)qCount
{
    self = [super init];
    if (nil == self) return nil;

    NSAssert(nil != name && nil != identifier && nil != qCount,
             @"ACMSurveyMetaData: Nil parameter passed to initWithName:identifier:");
    NSAssert(frequency == ACMSurveyFrequencyOnce || frequency == ACMSurveyFrequencyDaily, @"Illegal value passed as ACMSurveyFrequency");

    self.displayName = name;
    self.rkIdentifier = identifier;
    self.questionCount = qCount;
    self.frequency = frequency;

    return self;
}

@end
