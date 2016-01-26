#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>
#import <CloudMine/CloudMine.h>

@interface ACMConsentTaskResult : CMObject

- (nonnull instancetype)initWithTaskResult:(ORKTaskResult * _Nonnull)taskResult;

@end
