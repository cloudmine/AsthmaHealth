#import "ACMSurveyViewController.h"
#import <ResearchKit/ORKCompletionStep.h>

@interface ACMSurveyViewController ()

@end

@implementation ACMSurveyViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    self.task = ACMSurveyViewController.task;

    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

# pragma Task Construction

+ (ORKOrderedTask *)task
{
    return [[ORKOrderedTask alloc] initWithIdentifier:@"ACMAboutYouSurveyTask"
                                                steps:@[self.ethnicityQuestionStep, self.raceQuestionStep,
                                                        self.incomeQuestionStep, self.educationQuestionStep, self.completionStep]];
}

+ (ORKQuestionStep *)ethnicityQuestionStep
{
    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:self.ethnicityChoices];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:@"ACMAboutYouSurveyEthnicityQuestion"
                                                                      title:NSLocalizedString(@"Ethnicity", nil)
                                                                       text:nil
                                                                     answer:format];
    return question;
}

+ (NSArray<ORKTextChoice *> *)ethnicityChoices
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"Hispanic/Latino", nil), NSLocalizedString(@"Non-Hispanic/Latino", nil)];
    NSArray<NSString *> *keywords = @[@"HispanicLatino", @"NonHispanicLatino"];

    return [self questionChoices:choices withKeywords:keywords withQuestionIdWord:@"Ethnicity" exclusive:YES includesNoAnser:YES];
}

+ (ORKQuestionStep *)raceQuestionStep
{
    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleMultipleChoice textChoices:self.raceChoices];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:@"ACMAboutYouSurveyRaceQuestion"
                                                                      title:NSLocalizedString(@"Race", nil)
                                                                       text:NSLocalizedString(@"(Check all that apply)", nil)
                                                                     answer:format];
    return question;
}

+ (NSArray<ORKTextChoice *> *)raceChoices
{
    NSArray<NSString *> *races = @[NSLocalizedString(@"Black/African American", nil), NSLocalizedString(@"Asian", nil),
                                   NSLocalizedString(@"American Indian or Alaskan Native", nil), NSLocalizedString(@"Hawaiian or other Pacific Islander", nil),
                                   NSLocalizedString(@"White", nil), NSLocalizedString(@"Other", nil)];

    NSArray<NSString *> *raceKeywords = @[@"Black", @"Asian", @"NativeAmerican", @"PacificIslander", @"White", @"Other"];

    return [self questionChoices:races withKeywords:raceKeywords withQuestionIdWord:@"Race" exclusive:NO includesNoAnser:YES];
}

+ (ORKQuestionStep *)incomeQuestionStep
{
    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:self.incomeChoices];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:@"ACMAboutYouSurveyIncomeQuestion"
                                                                      title:NSLocalizedString(@"Which of the following best describes the total annual income of all members of your household?", nil)
                                                                       text:nil
                                                                     answer:format];

    return question;
}

+ (NSArray<ORKTextChoice *> *)incomeChoices
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"<$14,999", nil), NSLocalizedString(@"$15,000-21,999", nil),
                                     NSLocalizedString(@"$22,000-43,999", nil), NSLocalizedString(@"$44,000-60,000", nil),
                                     NSLocalizedString(@">$60,000", nil), NSLocalizedString(@"I don't know", nil)];

    NSArray<NSString *> *keywords = @[@"Tier1", @"Tier2", @"Tier3", @"Tier4", @"Tier5", @"DoNotKnow"];

    return [self questionChoices:choices withKeywords:keywords withQuestionIdWord:@"Income" exclusive:YES includesNoAnser:YES];
}

+ (ORKQuestionStep *)educationQuestionStep
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"8th Grade or Less", nil),
                                     NSLocalizedString(@"More than 8th grade but did not graduate high school", nil),
                                     NSLocalizedString(@"High school graduate or equivalent", nil),
                                     NSLocalizedString(@"Some College", nil),
                                     NSLocalizedString(@"Graduate of Two Year College or Technical School", nil),
                                     NSLocalizedString(@"Graduate of Four Year College", nil),
                                     NSLocalizedString(@"Post Graduate Studies", nil)];

    NSArray<NSString *> *keywords = @[@"NoHighSchool", @"SomeHighSchool", @"HighSchool",
                                      @"SomeCollege", @"TwoYearCollege", @"FourYearCollege", @"PostGrad"];

    return [self textQuestionWithTitle:NSLocalizedString(@"What is the highest level of education you have completed?", nil)
                            withIdWord:@"Education"
                       questionChoices:choices
                          withKeywords:keywords
                             exclusive:YES
                       includesNoAnser:YES];
}

+ (ORKQuestionStep *)textQuestionWithTitle:(NSString *)title
                                withIdWord:(NSString *)qId
                           questionChoices:(NSArray <NSString *> *)choices
                              withKeywords:(NSArray <NSString *> *)keywords
                                 exclusive:(BOOL)isExclusive
                           includesNoAnser:(BOOL)includesNo
{
    ORKChoiceAnswerStyle style = isExclusive ? ORKChoiceAnswerStyleSingleChoice : ORKChoiceAnswerStyleMultipleChoice;

    NSArray<ORKTextChoice *> *textChoices = [self questionChoices:choices
                                                 withKeywords:keywords withQuestionIdWord:qId exclusive:isExclusive includesNoAnser:includesNo];

    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:style textChoices:textChoices];
    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:[NSString stringWithFormat:@"ACMAboutYouSurvey%@Question", qId]
                                                                      title:title
                                                                       text:nil
                                                                     answer:format];
    return question;
}

+ (NSArray<ORKTextChoice *> *)questionChoices:(NSArray <NSString *> *)choices
                                 withKeywords:(NSArray <NSString *> *)keywords
                           withQuestionIdWord:(NSString *)qId
                                    exclusive:(BOOL)isExclusive
                              includesNoAnser:(BOOL)includesNo
{
    NSAssert(choices.count == keywords.count, @"Attempted to generate question text choices without an equal number of keyword IDs");

    NSMutableArray<ORKTextChoice *> *mutableChoices = [NSMutableArray new];

    for (int i = 0; i < choices.count; i++) {
        ORKTextChoice *choice = [[ORKTextChoice alloc] initWithText:choices[i]
                                                         detailText:nil
                                                              value:[NSString stringWithFormat:@"ACM%@%@Choice", qId, keywords[i]]
                                                          exclusive:isExclusive];

        [mutableChoices addObject:choice];
    }

    if (includesNo) {
        [mutableChoices addObject:[self noAnswerChoiceForQuestion:qId]];
    }

    return [mutableChoices copy];
}

+ (ORKTextChoice *)noAnswerChoiceForQuestion:(NSString *)questionId
{
    return [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"I choose not to answer", nil)
                             detailText:nil
                                  value:[NSString stringWithFormat:@"ACM%@ChooseNotToAnswerChoice", questionId]
                              exclusive:YES];
}

+ (ORKCompletionStep *)completionStep
{
    ORKCompletionStep *completion = [[ORKCompletionStep alloc] initWithIdentifier:@"ACMSurveyCompletionIdentifier"];
    completion.title = NSLocalizedString(@"Complete!", nil);
    return completion;
}

@end
