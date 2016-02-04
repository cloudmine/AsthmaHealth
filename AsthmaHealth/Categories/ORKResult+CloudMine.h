#import <Foundation/Foundation.h>
#import <ResearchKit/ResearchKit.h>
#import <CloudMine/CloudMine.h>

typedef void(^ACMSaveCompletion)(NSString *_Nullable uploadStatus, NSError *_Nullable error);
typedef void(^ACMFetchCompletion)(NSArray *_Nullable results, NSError *_Nullable error);

@interface ORKResult (CloudMine)<CMCoding>
- (void)cm_saveWithCompletion:(_Nullable ACMSaveCompletion)block;
+ (void)cm_fetchUserResultsWithCompletion:(_Nullable ACMFetchCompletion)block;
@end

@interface ORKConsentSignature (CloudMine)<CMCoding>
@end

@interface UIImage (CloudMine)<CMCoding>
@end

@interface NSUUID (CloudMine)<CMCoding>
@end
