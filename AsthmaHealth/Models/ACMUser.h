#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>

/** This is the lowest common demoninator approach to user abstraction.
    In the long run, this is probably  not good enough. We are carrying
    a lot of baggage from CMUser by subclassing that is not useful and
    potentially harmful for this application. A better approach in the future
    will likely be to create a user controller that encapsulates interaction
    with a CMUser but does not inherit from it, and instead exposes read-only public
    data about the user along with methods to take actions on the user server
    side. **/

typedef void(^ACMUserAuthCompletion)(NSError * _Nullable error);

@interface ACMUser : CMUser

- (nonnull instancetype)initWithEmail:(NSString * _Nonnull)theEmail
                          andPassword:(NSString * _Nonnull)thePassword
                     andConsentResult:(ORKTaskResult * _Nonnull)theConsentResult;

- (void)createAccountLoginAndUploadConsentWithCompletion:(_Nullable ACMUserAuthCompletion)block;

@end
