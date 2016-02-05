#import <Foundation/Foundation.h>

@interface ACMSurveyMetaData : NSObject

- (_Nonnull instancetype)initWithName:(NSString *_Nonnull)name identifier:(NSString *_Nonnull)identifier;

@property (nonatomic, nonnull, readonly) NSString *displayName;
@property (nonatomic, nonnull, readonly) NSString *rkIdentifier;

@end
