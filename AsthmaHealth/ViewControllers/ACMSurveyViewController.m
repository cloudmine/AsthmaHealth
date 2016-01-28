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
    return [[ORKOrderedTask alloc] initWithIdentifier:@"ACMAboutYouSurveyTask" steps:@[self.ethnicityQuestionStep, self.raceQuestionStep, self.completionStep]];
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
    ORKTextChoice *choice1 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"Hispanic/Latino", nil)
                                                      detailText:nil
                                                           value:@"ACMEthnicityHispanicLatinoChoice"
                                                       exclusive:YES];

    ORKTextChoice *choice2 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"Non-Hispanic/Latino", nil)
                                                      detailText:nil
                                                           value:@"ACMEthnicityNonHispanicLatinoChoice"
                                                       exclusive:YES];

    return @[choice1, choice2, [self noAnswerChoiceForQuestion:@"Ethnicity"]];
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

    NSAssert(races.count == raceKeywords.count, @"");

    NSMutableArray<ORKTextChoice *> *mutableChoices = [NSMutableArray new];
    for (int i = 0; i < races.count; i++) {
        ORKTextChoice *choice = [[ORKTextChoice alloc] initWithText:races[i]
                                                        detailText:nil
                                                             value:[NSString stringWithFormat:@"ACMRace%@Choice", raceKeywords[i]]
                                                         exclusive:NO];

        [mutableChoices addObject:choice];
    }

    [mutableChoices addObject:[self noAnswerChoiceForQuestion:@"Race"]];

    return  [mutableChoices copy];
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
