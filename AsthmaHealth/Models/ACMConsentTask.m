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
    reviewStep.reasonForConsent = NSLocalizedString(@"Consent to Join ACM Study", nil);

    ACMConsentTask *consentTask = [[ACMConsentTask alloc] initWithIdentifier:ACMConsentTaskIdentifier steps:@[consentStep, self.sharingOptionStep, reviewStep]];

    return consentTask;
}

# pragma mark Private Factories

+ (ORKQuestionStep *)sharingOptionStep
{
    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:self.sharingChoices];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:ACMSharingQuestionIdentifier
                                                                      title:NSLocalizedString(@"Sharing Option", nil)
                                                                       text:NSLocalizedString(@"Mount Sinai will receive your study data from your participation in this study.\n\nSharing your coded study data more broadly (without information such as your name) may benefit this and future research.", nil)
                                                                     answer:format];
    question.optional = NO;
    
    return question;
}

+ (NSArray<ORKTextChoice *> *)sharingChoices
{
    ORKTextChoice *choice1 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"Share my data with Mount Sinai and qualified researchers worldwide", nil)
                                                      detailText:nil
                                                           value:@"ACMSharingOptionBroad"
                                                       exclusive:YES];

    ORKTextChoice *choice2 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"Only share my data with Mount Sinai and its partners", nil)
                                                      detailText:nil
                                                           value:@"ACMSharingOptionNarrow"
                                                       exclusive:YES];

    return @[choice1, choice2];
}

@end
