#import "ACMTaskResultWrapper.h"

@implementation ORKCollectionResult (CloudMine)
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
