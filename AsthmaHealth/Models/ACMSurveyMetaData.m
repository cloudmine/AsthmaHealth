#import "ACMSurveyMetaData.h"

@interface ACMSurveyMetaData ()
@property (nonatomic, nonnull, readwrite) NSString *displayName;
@property (nonatomic, nonnull, readwrite) NSString *rkIdentifier;
@end

@implementation ACMSurveyMetaData

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name identifier:(NSString *)identifier
{
    self = [super init];
    if (nil == self) return nil;

    NSAssert(nil != name && nil != identifier,
             @"ACMSurveyMetaData: Nil parameter passed to initWithName:identifier:");

    self.displayName = name;
    self.rkIdentifier = identifier;

    return self;
}

@end
