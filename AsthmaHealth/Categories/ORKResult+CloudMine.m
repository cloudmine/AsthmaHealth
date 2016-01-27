#import "ORKResult+CloudMine.h"
#import <objc/runtime.h>
#import "ACMResultWrapper.h"

@implementation ORKResult (CloudMine)

- (void)cm_saveWithCompletion:(_Nullable ACMSaveCompletion)block
{
    Class resultWrapperClass = [ACMResultWrapper wrapperClassForResultClass:[self class]];
    
    NSAssert([[resultWrapperClass class] isSubclassOfClass:[ACMResultWrapper class]],
             @"Fatal Error: Result wrapper class not a result of ACMResultWrapper");

    ACMResultWrapper *resultWrapper = [[resultWrapperClass alloc] initWithResult:self];
    
    [resultWrapper saveWithUser:[CMStore defaultStore].user callback:^(CMObjectUploadResponse *response) {
        NSLog(@"Result Save Response: %@", response);

        if (nil != block) {
            block(nil);
        }
    }];
}

@end

@implementation ORKConsentSignature (CloudMine)
@end

@implementation UIImage (CloudMine)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(encodeWithCoder:);
        SEL swizzledSelector = @selector(acm_encodeWithCoder:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)acm_encodeWithCoder:(NSCoder *)aCoder
{
    if ([aCoder isKindOfClass:[CMObjectEncoder class]]) {
        NSLog(@"ENCODING UIImage HAS BEEN SWIZZLED");
        return;
    }

    [self acm_encodeWithCoder:aCoder];
}

@end

@implementation NSUUID (CloudMine)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(encodeWithCoder:);
        SEL swizzledSelector = @selector(acm_encodeWithCoder:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)acm_encodeWithCoder:(NSCoder *)aCoder
{
    if ([aCoder isKindOfClass:[CMObjectEncoder class]]) {
        [aCoder encodeObject:self.UUIDString forKey:@"UUIDString"];
        return;
    }

    [self acm_encodeWithCoder:aCoder];
}

// TODO: Swizzle decodeWithCoder

@end