#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>

@interface ACMResultWrapper : CMObject

- (_Nonnull instancetype)initWithResult:(ORKResult *_Nonnull)result;
+ (_Nonnull Class)wrapperClassForResultClass:(_Nonnull Class)resultClass;

@end
