#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>

@class ACMUserData;

typedef void(^ACMUserAuthCompletion)(NSError * _Nullable error);

@interface ACMUserController : NSObject

+ (_Nonnull instancetype)currentUser;

- (void)signUpWithEmail:(NSString *_Nonnull)email
               password:(NSString *_Nonnull)password
             andConsent:(ORKTaskResult *_Nonnull)consentResult
         withCompletion:(_Nullable ACMUserAuthCompletion)block;

@property (nonatomic, nullable, readonly) ACMUserData *userData;
@property (nonatomic, readonly) BOOL isLoggedIn;

@end
