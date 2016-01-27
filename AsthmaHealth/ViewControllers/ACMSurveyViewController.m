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
    return [[ORKOrderedTask alloc] initWithIdentifier:@"ACMSurveyTask" steps:@[self.sharingOptionStep, self.completionStep]];
}

+ (ORKQuestionStep *)sharingOptionStep
{
    ORKTextChoiceAnswerFormat *format = [[ORKTextChoiceAnswerFormat alloc] initWithStyle:ORKChoiceAnswerStyleSingleChoice textChoices:self.sharingChoices];

    ORKQuestionStep *question = [ORKQuestionStep questionStepWithIdentifier:@"ACMSurveyQuestionOne"
                                                                      title:NSLocalizedString(@"Best Survey", nil)
                                                                       text:NSLocalizedString(@"Is this the best survey ever?", nil)
                                                                     answer:format];
    question.optional = NO;

    return question;
}

+ (NSArray<ORKTextChoice *> *)sharingChoices
{
    ORKTextChoice *choice1 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"Definitely, I have never taken a better survey", nil)
                                                      detailText:nil
                                                           value:@"ACMBestSurveyOptionDefinitely"
                                                       exclusive:YES];

    ORKTextChoice *choice2 = [[ORKTextChoice alloc] initWithText:NSLocalizedString(@"Absolutely, this is the best survey I've every taken", nil)
                                                      detailText:nil
                                                           value:@"ACMBestSurveyOptionAbsolutely"
                                                       exclusive:YES];

    return @[choice1, choice2];
}

+ (ORKCompletionStep *)completionStep
{
    ORKCompletionStep *completion = [[ORKCompletionStep alloc] initWithIdentifier:@"ACMSurveyCompletionIdentifier"];
    completion.title = NSLocalizedString(@"Complete!", nil);
    return completion;
}

@end
