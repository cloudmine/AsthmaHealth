#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>

typedef void(^ACMUserAuthCompletion)(NSError * _Nullable error);

@interface ACMUser : CMUser

- (nonnull instancetype)initWithEmail:(NSString * _Nonnull)theEmail
                          andPassword:(NSString * _Nonnull)thePassword
                     andConsentResult:(ORKTaskResult * _Nonnull)theConsentResult;

- (void)createAccountLoginAndUploadConsentWithCompletion:(_Nullable ACMUserAuthCompletion)block;

@end
