#import "ACMDashboardViewController.h"
#import <ResearchKit/ResearchKit.h>
#import "ACMSurveyViewController.h"
#import "ORKResult+CloudMine.h"


@interface ACMDashboardViewController ()<ORKTaskViewControllerDelegate>
@property (nonatomic, nullable) ORKTaskResult *surveyResult;
@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((ORKTaskViewController *)segue.destinationViewController).delegate = self;
}

#pragma mark ORKTaskViewControllerDelegate

- (void)taskViewController:(ORKTaskViewController *)taskViewController didFinishWithReason:(ORKTaskViewControllerFinishReason)reason error:(NSError *)error
{
    if (nil != error) {
        NSLog(@"Consent Error: %@", error.localizedDescription);
        return;
    }

    switch (reason) {
        case ORKTaskViewControllerFinishReasonCompleted:
            [self handleSurveyCompleted];
            return;
        case ORKTaskViewControllerFinishReasonDiscarded:
            NSLog(@"Consent Discarded");
            break;
        case ORKTaskViewControllerFinishReasonFailed:
            NSLog(@"Consent Failed");
            break;
        case ORKTaskViewControllerFinishReasonSaved:
            NSLog(@"Consent Saved");
            break;
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSurveyCompleted
{
    NSAssert([self.presentedViewController isKindOfClass:[ACMSurveyViewController class]],
             @"Attempted to handle a survey completion when a ACMSurveyViewController was not presented");
    
    self.surveyResult = ((ACMSurveyViewController *)self.presentedViewController).result;

    [self.surveyResult cm_saveWithCompletion:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
