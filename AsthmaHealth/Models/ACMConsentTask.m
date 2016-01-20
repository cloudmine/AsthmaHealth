#import "ACMConsentTask.h"

static NSString *const ACMReviewConsentIdentifier = @"ACMParticipantConsentReview";

@implementation ACMConsentTask

#pragma mark Factory

// TODO: Ponder, is a subclass actually neccessary?
+ (instancetype)task
{
    ACMConsentDocument *consentDoc = [ACMConsentDocument new];

    ORKVisualConsentStep *consentStep = [[ORKVisualConsentStep alloc] initWithIdentifier:@"Constent Step Id" document:consentDoc];

    ORKConsentReviewStep *reviewStep = [[ORKConsentReviewStep alloc] initWithIdentifier:ACMReviewConsentIdentifier signature:consentDoc.signatures.firstObject inDocument:consentDoc];
    reviewStep.text = NSLocalizedString(@"Review ACM Consent", nil);
    reviewStep.reasonForConsent = NSLocalizedString(@"Consent to Join ACM Study", nil);

    ACMConsentTask *consentTask = [[ACMConsentTask alloc] initWithIdentifier:@"Identifier" steps:@[consentStep, reviewStep]];

    return consentTask;
}

@end
