#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>

@interface ACMResultWrapper : CMObject

- (_Nonnull instancetype)initWithResult:(ORKResult *_Nonnull)result;

+ (Class)wrapperClassForResultClass:(Class)resultClass;

@end
