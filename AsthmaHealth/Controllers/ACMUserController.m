#import "ACMUserController.h"
#import "ACMUserData.h"
#import <CloudMine/CloudMine.h>
#import "ORKResult+CloudMine.h"

@interface CRKUser : CMUser

@property (nonatomic) NSString *givenName;
@property (nonatomic) NSString *familyName;

@end

@implementation CRKUser

+ (instancetype)currentUser
{
    return [super currentUser];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    self.givenName = [aDecoder decodeObjectForKey:@"givenName"];
    self.familyName = [aDecoder decodeObjectForKey:@"familyName"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    if (nil != self.givenName) {
        [aCoder encodeObject:self.givenName forKey:@"givenName"];
    }

    if (nil != self.familyName) {
        [aCoder encodeObject:self.familyName forKey:@"familyName"];
    }
}

@end

@interface ACMUserData () // In an SDK this would likely go in a private/internal header file
- (instancetype)initWithCRKUser:(CRKUser *)user;
@property (nonatomic, nonnull, readwrite) NSString *email;
@property (nonatomic, nullable, readwrite) NSString *familyName;
@property (nonatomic, nullable, readwrite) NSString *givenName;
@end

@implementation ACMUserData

- (instancetype)initWithCRKUser:(CRKUser *)user
{
    self = [super init];
    if (nil == self || nil == user) return nil;

    self.email = user.email;
    self.familyName = user.familyName;
    self.givenName = user.givenName;

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
        _sharedInstance.userData = [[ACMUserData alloc] initWithCRKUser:[CRKUser currentUser]];

        // Need to think more carefully about this. It probably doesn't belong here, but I think
        // a goal should be to hide the sense of a "store" from the SDK consumer. We need to perform
        // this side effect somewhere, but where?
        [CMStore defaultStore].user = [CRKUser currentUser];
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
    self.userData = nil;
    CRKUser *newUser = [[CRKUser alloc] initWithEmail:email andPassword:password];
    [CMStore defaultStore].user = newUser;

    // TODO: Somewhere, we need to verify the ORKTaskResult is a consent result and the user actually consented
    ORKConsentSignatureResult *signatureResult = [ACMUserController signatureInResults:consentResult.results];
    newUser.familyName = signatureResult.signature.familyName;
    newUser.givenName = signatureResult.signature.givenName;

    [newUser createAccountAndLoginWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        if (CMUserAccountOperationFailed(resultCode)) {
            if (nil != block) {
                NSError *error = [ACMUserController errorWithMessage:NSLocalizedString(@"Failed to create account and login", nil)
                                                             andCode:(100 + resultCode)];
                block(error);
            }
            return;
        }

        self.userData = [[ACMUserData alloc] initWithCRKUser:[CRKUser currentUser]];

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

- (void)loginWithEmail:(NSString *_Nonnull)email
              password:(NSString *_Nonnull)password
         andCompletion:(_Nullable ACMUserAuthCompletion)block
{
    NSAssert(nil != email, @"ACMUserController: Attempted to login with nil email");
    NSAssert(nil != password, @"ACMUserController: Attempted to login with nil password");

    self.userData = nil;
    CRKUser *user = [[CRKUser alloc] initWithEmail:email andPassword:password];
    [CMStore defaultStore].user = user;

    [user loginWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        if (CMUserAccountOperationFailed(resultCode)) {
            if (nil != block) {
                NSError *error = [ACMUserController errorWithMessage:NSLocalizedString(@"Failed to log in", nil)  // TODO: different domain?
                                                             andCode:(100 + resultCode)];
                block(error);
            }
            return;
        }

        self.userData = [[ACMUserData alloc] initWithCRKUser:[CRKUser currentUser]];

        if (nil != block) {
            block(nil);
        }
    }];
}

- (void)logoutWithCompletion:(_Nullable ACMUserLogoutCompletion)block
{
    [[CRKUser currentUser] logoutWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        if (CMUserAccountOperationFailed(resultCode)) {
            if (nil != block) {
                NSError *error = [ACMUserController errorWithMessage:NSLocalizedString(@"Failed to logout", nil)  // TODO: different domain?
                                                             andCode:(100 + resultCode)];
                block(error);
            }
            return;
        }

        self.userData = nil;

        if (nil != block) {
            block(nil);
        }
    }];
}

- (BOOL)isLoggedIn
{
    return nil != [CRKUser currentUser] && [CRKUser currentUser].isLoggedIn;
}

# pragma mark Private

+ (ORKConsentSignatureResult *_Nullable)signatureInResults:(NSArray<ORKResult *> *_Nullable)results
{
    if (nil == results) {
        return nil;
    }

    // Check these results
    for (ORKResult *aResult in results) {
        if ([aResult isKindOfClass:[ORKConsentSignatureResult class]]) {
            return (ORKConsentSignatureResult *)aResult;
        }
    }

    // Recusrively check results of results
    for (ORKResult *aResult in results) {
        if (![aResult respondsToSelector:@selector(results)]) {
            continue;
        }

        ORKConsentSignatureResult *recusrivResult = [self signatureInResults:[aResult performSelector:@selector(results)]];
        if (nil != recusrivResult) {
            return recusrivResult;
        }
    }

    return nil;
}

+ (NSError * _Nullable)errorWithMessage:(NSString * _Nonnull)message andCode:(NSInteger)code
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: message };
    NSError *error = [NSError errorWithDomain:@"ACMUserAuthenticationError" code:code userInfo:userInfo];
    return error;
}

@end
