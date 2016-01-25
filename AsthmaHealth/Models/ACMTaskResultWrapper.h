#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>
#import <CloudMine/CloudMine.h>

@interface ORKResult (CloudMine)<CMCoding>
@end

@interface ORKConsentSignature (CloudMine)<CMCoding>
@end

@interface UIImage (CloudMine)<CMCoding>
@end

@interface NSUUID (CloudMine)<CMCoding>
@end

@interface ACMTaskResultWrapper : CMObject

- (nonnull instancetype)initWithTaskResult:(ORKTaskResult * _Nonnull)taskResult;

@end
