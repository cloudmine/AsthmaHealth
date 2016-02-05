#import "ACMSurveyFactory.h"
#import <ResearchKit/ORKCompletionStep.h>

@implementation ACMSurveyFactory

+ (ORKTaskViewController *_Nullable)surveyViewControllerForIdentifier:(NSString *_Nullable)surveyIdentifier
{
    if (nil == surveyIdentifier) {
        return nil;
    }

    if ([@"ACMAboutYouSurveyTask" isEqualToString:surveyIdentifier]) {
        return [[ORKTaskViewController alloc] initWithTask:self.aboutYouTask taskRunUUID:nil];
    } else if([@"ACMDailySurveyTask" isEqualToString:surveyIdentifier]) {
        return [[ORKTaskViewController alloc] initWithTask:self.dailyTask taskRunUUID:nil];
    }

    return nil;
}

# pragma mark "Daily" Task

+ (ORKOrderedTask *)dailyTask
{
    return [[ORKOrderedTask alloc] initWithIdentifier:@"ACMDailySurveyTask" steps:self.dailySteps];
}

# pragma mark "About You" Task

+ (ORKOrderedTask *)aboutYouTask
{
    ORKNavigableOrderedTask *task = [[ORKNavigableOrderedTask alloc] initWithIdentifier:@"ACMAboutYouSurveyTask"
                                                                                  steps:self.aboutYouSteps];

    ORKResultSelector *smokingStatus = [ORKResultSelector selectorWithResultIdentifier:@"ACMAboutYouSurveySmokingQuestion"];
    NSPredicate *notSmokerPredicate = [ORKResultPredicate predicateForChoiceQuestionResultWithResultSelector:smokingStatus expectedAnswerValues:@[@"ACMSmokingNeverChoice"]];

    ORKPredicateStepNavigationRule *predicateRule = [[ORKPredicateStepNavigationRule alloc] initWithResultPredicates:@[notSmokerPredicate] destinationStepIdentifiers:@[@"ACMAboutYouSurveyInsuranceQuestion"]];

    [task setNavigationRule:predicateRule forTriggerStepIdentifier:@"ACMAboutYouSurveySmokingQuestion"];

    return task;
}

#pragma mark "Daily" Steps
+ (NSArray<ORKStep *> *)dailySteps
{
    return @[self.daytimeQuestion];
}

+ (ORKQuestionStep *)daytimeQuestion
{
    return [ORKQuestionStep questionStepWithIdentifier:@"ACMDailySurveyDaytimeQuestion"
                                                 title:NSLocalizedString(@"In the last 24 hours, did you have any daytime asthma symptoms (cough, wheeze, shortness of breath or chest tightness)?", nil)
                                                  text:@""
                                                answer:[ORKBooleanAnswerFormat new]];
}

# pragma mark "About You" Steps

+ (NSArray<ORKStep *> *)aboutYouSteps
{
    return @[self.ethnicityQuestionStep, self.raceQuestionStep, self.incomeQuestionStep, self.educationQuestionStep, self.smokingQuestionStep,
             self.cigaretteCountStep, self.smokingYearsStep, self.insuranceQuestionStep, self.completionStep];
}

+ (ORKQuestionStep *)ethnicityQuestionStep
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"Hispanic/Latino", nil), NSLocalizedString(@"Non-Hispanic/Latino", nil)];
    NSArray<NSString *> *keywords = @[@"HispanicLatino", @"NonHispanicLatino"];

    return [self textQuestionWithTitle:NSLocalizedString(@"Ethnicity", nil)
                            withIdWord:@"Ethnicity"
                       questionChoices:choices
                          withKeywords:keywords
                             exclusive:YES
                      includesNoAnswer:YES];
}

+ (ORKQuestionStep *)raceQuestionStep
{
    NSArray<NSString *> *races = @[NSLocalizedString(@"Black/African American", nil), NSLocalizedString(@"Asian", nil),
                                   NSLocalizedString(@"American Indian or Alaskan Native", nil), NSLocalizedString(@"Hawaiian or other Pacific Islander", nil),
                                   NSLocalizedString(@"White", nil), NSLocalizedString(@"Other", nil)];

    NSArray<NSString *> *raceKeywords = @[@"Black", @"Asian", @"NativeAmerican", @"PacificIslander", @"White", @"Other"];

    return [self textQuestionWithTitle:NSLocalizedString(@"Race (Check all that apply)", nil)
                            withIdWord:@"Race"
                       questionChoices:races
                          withKeywords:raceKeywords
                             exclusive:NO
                      includesNoAnswer:YES];
}

+ (ORKQuestionStep *)incomeQuestionStep
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"<$14,999", nil), NSLocalizedString(@"$15,000-21,999", nil),
                                     NSLocalizedString(@"$22,000-43,999", nil), NSLocalizedString(@"$44,000-60,000", nil),
                                     NSLocalizedString(@">$60,000", nil), NSLocalizedString(@"I don't know", nil)];

    NSArray<NSString *> *keywords = @[@"Tier1", @"Tier2", @"Tier3", @"Tier4", @"Tier5", @"DoNotKnow"];

    return [self textQuestionWithTitle:NSLocalizedString(@"Which of the following best describes the total annual income of all members of your household?", nil)
                            withIdWord:@"Income"
                       questionChoices:choices
                          withKeywords:keywords
                             exclusive:YES
                      includesNoAnswer:YES];
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
                      includesNoAnswer:YES];
}

+ (ORKQuestionStep *)smokingQuestionStep
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"Never (<100 Cigarettes in lieftime)", nil),
                                     NSLocalizedString(@"Current", nil), NSLocalizedString(@"Former", nil)];
    NSArray<NSString *> *keywords = @[@"Never", @"Current", @"Former"];

    return [self textQuestionWithTitle:NSLocalizedString(@"What is your smoking status?", nil)
                            withIdWord:@"Smoking"
                       questionChoices:choices
                          withKeywords:keywords
                             exclusive:YES
                      includesNoAnswer:NO];
}

+ (ORKQuestionStep *)cigaretteCountStep
{
    ORKNumericAnswerFormat *format = [[ORKNumericAnswerFormat alloc] initWithStyle:ORKNumericAnswerStyleInteger
                                                                              unit:NSLocalizedString(@"Cigarettes", nil)
                                                                           minimum:@1 maximum:@200];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:@"ACMAboutYouSurveyCigarettesQuestion"
                                                                      title:NSLocalizedString(@"On average, how many cigarettes per day did you smoke daily?", nil)
                                                                       text:nil
                                                                     answer:format];
    return question;
}

+ (ORKQuestionStep *)smokingYearsStep
{
    ORKNumericAnswerFormat *format = [[ORKNumericAnswerFormat alloc] initWithStyle:ORKNumericAnswerStyleInteger
                                                                              unit:NSLocalizedString(@"Years", nil)
                                                                           minimum:@0 maximum:@100];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:@"ACMAboutYouSurveyYearsSmokingQuestion"
                                                                      title:NSLocalizedString(@"How many years in total did you smoke?", nil)
                                                                       text:nil
                                                                     answer:format];
    return question;
}

+ (ORKQuestionStep *)insuranceQuestionStep
{
    NSArray<NSString *> *choices = @[NSLocalizedString(@"Private (bought by you or your employer", nil),
                                     NSLocalizedString(@"Public (Medicare or Medicade", nil),
                                     NSLocalizedString(@"I have no health insurance", nil)];

    NSArray<NSString *> *keywords = @[@"Private", @"Public", @"NoIsurance"];

    return [self textQuestionWithTitle:NSLocalizedString(@"Do you have health insurance?", nil)
                            withIdWord:@"Insurance"
                       questionChoices:choices
                          withKeywords:keywords
                             exclusive:YES
                      includesNoAnswer:YES];
}

+ (ORKCompletionStep *)completionStep
{
    ORKCompletionStep *completion = [[ORKCompletionStep alloc] initWithIdentifier:@"ACMSurveyCompletionIdentifier"];
    completion.title = NSLocalizedString(@"Complete!", nil);
    return completion;
}

#pragma mark Generator Methods

+ (ORKQuestionStep *)textQuestionWithTitle:(NSString *)title
                                withIdWord:(NSString *)qId
                           questionChoices:(NSArray <NSString *> *)choices
                              withKeywords:(NSArray <NSString *> *)keywords
                                 exclusive:(BOOL)isExclusive
                           includesNoAnswer:(BOOL)includesNo
{
    ORKChoiceAnswerStyle style = isExclusive ? ORKChoiceAnswerStyleSingleChoice : ORKChoiceAnswerStyleMultipleChoice;

    NSArray<ORKTextChoice *> *textChoices = [self questionChoices:choices
                                                 withKeywords:keywords withQuestionIdWord:qId exclusive:isExclusive includesNoAnswer:includesNo];

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
                              includesNoAnswer:(BOOL)includesNo
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

@end
