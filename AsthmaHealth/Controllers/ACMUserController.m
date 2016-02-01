#import "ACMUserController.h"
#import "ACMUserData.h"
#import <CloudMine/CloudMine.h>

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

- (BOOL)isLoggedIn
{
    return nil != [CMUser currentUser] && [CMUser currentUser].isLoggedIn;
}

@end
