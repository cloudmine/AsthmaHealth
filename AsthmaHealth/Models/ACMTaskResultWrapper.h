#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>
#import <CloudMine/CloudMine.h>

@interface ORKResult (CloudMine)<CMCoding>
@end

@interface ORKConsentSignature (CloudMine)<CMCoding>
@end

@interface UIImage (CloudMine)<CMCoding>
@end

@interface NSData (CloudMine)<CMCoding>
@end

@interface UITraitCollection (CloudMine)<CMCoding>
@end

@interface NSUUID (CloudMine)<CMCoding>
@end

@interface CMObjectEncoder (CMORK)
- (void)encodeBytes:(nullable const void *)byteaddr length:(NSUInteger)length;
- (void)encodeBytes:(nullable const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key;
@end

@interface ACMTaskResultWrapper : CMObject

- (nonnull instancetype)initWithTaskResult:(ORKTaskResult * _Nonnull)taskResult;

@end
