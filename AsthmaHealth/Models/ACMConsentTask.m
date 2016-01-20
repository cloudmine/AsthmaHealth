#import "ACMConsentTask.h"

@implementation ACMConsentTask

#pragma mark Factory

+ (instancetype)task
{
    ACMConsentDocument *consentDoc = [ACMConsentDocument new];

    ORKVisualConsentStep *consentStep = [[ORKVisualConsentStep alloc] initWithIdentifier:@"Constent Step Id" document:consentDoc];

    ACMConsentTask *consentTask = [[ACMConsentTask alloc] initWithIdentifier:@"Identifier" steps:@[consentStep]];

    return consentTask;
}

@end
