#import <Foundation/Foundation.h>

@interface ACMSurveyMetaData : NSObject

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name
                           identifier:(NSString *_Nonnull)identifier
                     andQuestionCount:(NSNumber *_Nonnull)qCount;

@property (nonatomic, nonnull, readonly) NSString *displayName;
@property (nonatomic, nonnull, readonly) NSString *rkIdentifier;
@property (nonatomic, nonnull, readonly) NSNumber *questionCount;

@end
