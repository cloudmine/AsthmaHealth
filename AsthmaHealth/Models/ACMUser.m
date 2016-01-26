#import "ACMUser.h"
#import "ACMConsentTaskResult.h"

@interface ACMUser ()
@property (nonatomic, nullable) ORKTaskResult *consentResult;
@end

@implementation ACMUser

- (nonnull instancetype)initWithEmail:(NSString * _Nonnull)theEmail
                          andPassword:(NSString * _Nonnull)thePassword
                     andConsentResult:(ORKTaskResult * _Nonnull)theConsentResult
{
    self = [super initWithEmail:theEmail andPassword:thePassword];
    if (nil == self || nil == theConsentResult) {
        return nil;
    }

    self.consentResult = theConsentResult;
    [CMStore defaultStore].user = self;

    return self;
}

- (void)createAccountLoginAndUploadConsentWithCompletion:(ACMUserAuthCompletion)block
{
    [super createAccountAndLoginWithCallback:^(CMUserAccountResult resultCode, NSArray *messages) {
        if (CMUserAccountOperationFailed(resultCode)) {
            if (nil != block) {
                NSError *error = [ACMUser errorWithMessage:NSLocalizedString(@"Failed to create account and login", nil)
                                                   andCode:(100 + resultCode)];
                block(error);
            }
            return;
        }

        ACMConsentTaskResult *resultWrapper = [[ACMConsentTaskResult alloc] initWithTaskResult:self.consentResult];
        [resultWrapper saveWithUser:self callback:^(CMObjectUploadResponse *response) {
            NSLog(@"Status: %@", [response.uploadStatuses objectForKey:resultWrapper.objectId]);

            NSString *status = [response.uploadStatuses objectForKey:resultWrapper.objectId];
            if (![@"created" isEqualToString:status]) {
                if (nil != block) {
                    NSError *error = [ACMUser errorWithMessage:[NSString localizedStringWithFormat:@"Failed to create consent object, status: %@", status]
                                                       andCode:200];
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

# pragma mark Private

+ (NSError * _Nullable)errorWithMessage:(NSString * _Nonnull)message andCode:(NSInteger)code
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: message };
    NSError *error = [NSError errorWithDomain:@"ACMUserAuthenticationError" code:code userInfo:userInfo];
    return error;
}

@end
