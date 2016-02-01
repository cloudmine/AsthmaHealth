#import "ACMUserController.h"
#import "ACMUserData.h"
#import <CloudMine/CloudMine.h>
#import "ORKResult+CloudMine.h"

@interface ACMUserData ()
- (instancetype)initWithCMUser:(CMUser *)user; // In an SDK this would likely go in a private/internal header file
@property (nonatomic, nonnull, readwrite) NSString *email;
@end

@implementation ACMUserData

- (instancetype)initWithCMUser:(CMUser *)user
{
    self = [super init];
    if (nil == self || nil == user) return nil;

    self.email = user.email;

    return self;
}

@end

@interface ACMUserController ()
@property (nonatomic, nullable, readwrite) ACMUserData *userData;
@end

@implementation ACMUserController

+ (instancetype)currentUser
{
    static ACMUserController *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [ACMUserController new];
        _sharedInstance.userData = [[ACMUserData alloc] initWithCMUser:[CMUser currentUser]];

        // Need to think more carefully about this. It probably doesn't belong here, but I think
        // a goal should be to hide the sense of a "store" from the SDK consumer. We need to perform
        // this side effect somewhere, but where?
        [CMStore defaultStore].user = [CMUser currentUser];
    });

    return _sharedInstance;
}


// TODO: Ponder: this is nice from a consumption standpoint, but could leave the user in a weird place if account creation succeeds
// but uploading consent fails. Need to think more broadly about what the SDK will actually provide in terms of consent flows.
// Somehow this probably needs to be seperated into two steps: signup, upload consent.
- (void)signUpWithEmail:(NSString *_Nonnull)email
               password:(NSString *_Nonnull)password
             andConsent:(ORKTaskResult *_Nonnull)consentResult
         withCompletion:(_Nullable ACMUserAuthCompletion)block
{
    CMUser *newUser = [[CMUser alloc] initWithEmail:email andPassword:password];
    [CMStore defaultStore].user = newUser;

    // TODO: Somewhere, we need to verify the ORKTaskResult is a consent result and the user actually consented

    [newUser createAccountAndLoginWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        if (CMUserAccountOperationFailed(resultCode)) {
            if (nil != block) {
                NSError *error = [ACMUserController errorWithMessage:NSLocalizedString(@"Failed to create account and login", nil)
                                                             andCode:(100 + resultCode)];
                block(error);
            }
            return;
        }

        self.userData = [[ACMUserData alloc] initWithCMUser:[CMUser currentUser]];

        [consentResult cm_saveWithCompletion:^(NSString * _Nullable uploadStatus, NSError * _Nullable error) {
            if (nil == uploadStatus) {
                if (nil != block) {
                    NSString *uploadErrorMessage = [NSString localizedStringWithFormat:@"Failed to create consent object; %@", error.localizedDescription];
                    NSError *error = [ACMUserController errorWithMessage:uploadErrorMessage
                                                                 andCode:error.code];
                    block(error);
                }

                return;
            }

            if (nil != block) {
                block(nil);
            }
        }];
    }];
}

- (void)logoutWithCompletion:(_Nullable ACMUserLogoutCompletion)block
{
    [[CMUser currentUser] logoutWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        if (CMUserAccountOperationFailed(resultCode)) {
            if (nil != block) {
                NSError *error = [ACMUserController errorWithMessage:NSLocalizedString(@"Failed to logout", nil)  // TODO: different domain?
                                                             andCode:(100 + resultCode)];
                block(error);
            }
            return;
        }

        if (nil != block) {
            block(nil);
        }
    }];
}

- (BOOL)isLoggedIn
{
    return nil != [CMUser currentUser] && [CMUser currentUser].isLoggedIn;
}

# pragma mark Private

+ (NSError * _Nullable)errorWithMessage:(NSString * _Nonnull)message andCode:(NSInteger)code
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: message };
    NSError *error = [NSError errorWithDomain:@"ACMUserAuthenticationError" code:code userInfo:userInfo];
    return error;
}

@end
