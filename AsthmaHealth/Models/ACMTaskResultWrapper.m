#import "ACMTaskResultWrapper.h"

@implementation ORKResult (CloudMine)
@end

@implementation ORKConsentSignature (CloudMine)
@end

@implementation UIImage (CloudMine)
@end

@implementation NSData (CloudMine)
@end

@implementation UITraitCollection (CloudMine)
@end

@implementation NSUUID (CloudMine)
@end

@implementation CMObjectEncoder (CMORK)
- (void)encodeBytes:(nullable const void *)byteaddr length:(NSUInteger)length
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)encodeBytes:(nullable const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
@end


@interface ACMTaskResultWrapper ()
@property (nonatomic, nonnull) ORKTaskResult *taskResult;
@end

@implementation ACMTaskResultWrapper

- (nonnull instancetype)initWithTaskResult:(ORKTaskResult * _Nonnull)taskResult
{
    self = [super init];
    if (nil == self || nil == taskResult) { return nil; }

    if (![taskResult conformsToProtocol:@protocol(CMCoding)]) {
        NSLog(@"UGH");
    }

    self.taskResult = taskResult;

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [self.taskResult encodeWithCoder:aCoder];
}

@end
