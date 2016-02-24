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

    ACMConsentTask *consentTask = [[ACMConsentTask alloc] initWithIdentifier:ACMConsentTaskIdentifier steps:@[consentStep, self.sharingOptionStep, reviewStep]];

    return consentTask;
}

# pragma mark Private Factories

+ (ORKQuestionStep *)sharingOptionStep
{
    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:self.sharingChoices];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:ACMSharingQuestionIdentifier
                                                                      title:NSLocalizedString(@"ACMConsentTaskSharingOptionTitle", nil)
                                                                       text:NSLocalizedString(@"ACMConsentTaskSharingOptionText", nil)
                                                                     answer:format];
    question.optional = NO;
    
    return question;
}

+ (NSArray<ORKTextChoice *> *)sharingChoices
{
    ORKTextChoice *choice1 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"ACMConsentTaskSharingChoicesText1", nil)
                                                      detailText:nil
                                                           value:@"ACMSharingOptionBroad"
                                                       exclusive:YES];

    ORKTextChoice *choice2 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"ACMConsentTaskSharingChoicesText2", nil)
                                                      detailText:nil
                                                           value:@"ACMSharingOptionNarrow"
                                                       exclusive:YES];

    return @[choice1, choice2];
}

@end
