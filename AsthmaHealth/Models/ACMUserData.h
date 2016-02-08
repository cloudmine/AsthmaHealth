#import <Foundation/Foundation.h>

@interface ACMUserData : NSObject

@property (nonatomic, nonnull, readonly) NSString *email;
@property (nonatomic, nullable, readonly) NSString *familyName;
@property (nonatomic, nullable, readonly) NSString *givenName;

@end
