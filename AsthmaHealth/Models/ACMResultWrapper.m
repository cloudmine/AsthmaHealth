#import "ACMResultWrapper.h"
#import <objc/runtime.h>

@interface ACMResultWrapper ()
@property (nonatomic, nonnull) ORKResult *result;

@end

@implementation ACMResultWrapper

- (instancetype)initWithResult:(ORKResult *)result
{
    self = [super init];
    if (nil == self) return nil;

    self.result = result;

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self.result encodeWithCoder:aCoder];
}

// Returns the name of the wrapped class, rather than the wrapper class name itself
+ (NSString *)className
{
    NSError *regexError = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"^ACM(\\w+)Wrapper$" options:0 error:&regexError];

    if (nil != regexError) {
        return [super className];
    }

    NSString *className = NSStringFromClass([self class]);
    NSArray<NSTextCheckingResult *> *matches = [regEx matchesInString:className options:0 range:NSMakeRange(0, className.length)];
    if (matches.count != 1) {
        return [super className];
    }

    NSTextCheckingResult *match = matches.firstObject;
    if(nil == match) {
        return [super className];
    }

    NSRange matchRange = [match rangeAtIndex:1];
    NSString *extractedName = [className substringWithRange:matchRange];
    if (nil == extractedName) {
        return [super className];
    }

    return extractedName;
}

// Returns a dynamically created subclass of ACMResultWrapper named for the class it will wrap
+ (Class)wrapperClassForResultClass:(Class)resultClass
{
    NSString *resultClassName = NSStringFromClass(resultClass);
    NSString *wrapperClassName = [NSString stringWithFormat:@"ACM%@Wrapper", resultClassName];

    Class exisitingWrapperClass = NSClassFromString(wrapperClassName);
    if (nil != exisitingWrapperClass) {
        return exisitingWrapperClass;
    }

    Class wrapperClass = objc_allocateClassPair([self class], [wrapperClassName cStringUsingEncoding:NSASCIIStringEncoding], 0);
    objc_registerClassPair(wrapperClass);

    return wrapperClass;
}

@end