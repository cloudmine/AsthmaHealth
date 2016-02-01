#import <Foundation/Foundation.h>

@class ACMUserData;

@interface ACMUserController : NSObject

+ (_Nonnull instancetype)currentUser;

@property (nonatomic, nullable, readonly) ACMUserData *userData;
@property (nonatomic, readonly) BOOL isLoggedIn;

@end
