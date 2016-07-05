#import "ACMConsentTask.h"

static NSString *const ACMConsentStepIdentifier     = @"ACMParticipantConsentStep";
static NSString *const ACMReviewConsentIdentifier   = @"ACMParticipantConsentReview";
static NSString *const ACMSharingQuestionIdentifier = @"ACMParticipantConsentSharingQuestion";
static NSString *const ACMConsentTaskIdentifier     = @"ACMParticipantConsentTask";

@implementation ACMConsentTask

#pragma mark Factory

// TODO: Ponder, is a subclass actually neccessary?
+ (instancetype)task
{
    ACMConsentDocument *consentDoc = [ACMConsentDocument new];

    ORKVisualConsentStep *consentStep = [[ORKVisualConsentStep alloc] initWithIdentifier:ACMConsentStepIdentifier document:consentDoc];

    ORKConsentReviewStep *reviewStep = [[ORKConsentReviewStep alloc] initWithIdentifier:ACMReviewConsentIdentifier signature:consentDoc.signatures.firstObject inDocument:consentDoc];
    reviewStep.reasonForConsent = NSLocalizedString(@"ACMConsentTaskReason", nil);

    ACMConsentTask *consentTask = [[ACMConsentTask alloc] initWithIdentifier:ACMConsentTaskIdentifier
                                                                       steps:@[consentStep, self.sharingStep,
                                                                               reviewStep, self.registrationStep]];

    return consentTask;
}

# pragma mark Private Factories

+ (ORKConsentSharingStep *)sharingStep
{
    return [[ORKConsentSharingStep alloc] initWithIdentifier:ACMSharingQuestionIdentifier
                                investigatorShortDescription:NSLocalizedString(@"ACMInstitutionNameShortText", nil)
                                 investigatorLongDescription:NSLocalizedString(@"ACMInstitutionNameShortText", nil)
                               localizedLearnMoreHTMLContent:NSLocalizedString(@"ACMConsentTaskSharingOptionText", nil)];
}

+ (ORKRegistrationStep *)registrationStep
{
    ORKRegistrationStepOption options = ORKRegistrationStepIncludeDOB       | ORKRegistrationStepIncludeGender |
                                        ORKRegistrationStepIncludeGivenName | ORKRegistrationStepIncludeFamilyName;
    
    return [[ORKRegistrationStep alloc] initWithIdentifier:@"ACMParticipantRegistrationStep"
                                                     title:NSLocalizedString(@"Registration", nil)
                                                      text:NSLocalizedString(@"Create an account", nil)
                                                   options:options];
}

@end
