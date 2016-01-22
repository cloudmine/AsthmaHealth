#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>
#import <CloudMine/CloudMine.h>

@interface ORKCollectionResult (CloudMine)<CMCoding>
@end

@interface ORKStepResult (CloudMine)<CMCoding>
@end

@interface ACMTaskResultWrapper : CMObject

- (nonnull instancetype)initWithTaskResult:(ORKTaskResult * _Nonnull)taskResult;

@end
