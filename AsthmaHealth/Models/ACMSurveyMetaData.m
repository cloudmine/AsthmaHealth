#import "ACMSurveyMetaData.h"

@interface ACMSurveyMetaData ()
@property (nonatomic, nonnull, readwrite) NSString *displayName;
@property (nonatomic, nonnull, readwrite) NSString *rkIdentifier;
@property (nonatomic, nonnull, readwrite) NSNumber *questionCount;
@end

@implementation ACMSurveyMetaData

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name identifier:(NSString *_Nonnull)identifier andQuestionCount:(NSNumber * _Nonnull)qCount
{
    self = [super init];
    if (nil == self) return nil;

    NSAssert(nil != name && nil != identifier && nil != qCount,
             @"ACMSurveyMetaData: Nil parameter passed to initWithName:identifier:");

    self.displayName = name;
    self.rkIdentifier = identifier;
    self.questionCount = qCount;

    return self;
}

@end
