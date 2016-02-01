#import "ACMActivitiesViewController.h"
#import <ResearchKit/ResearchKit.h>
#import "ACMSurveyViewController.h"
#import "ORKResult+CloudMine.h"


@interface ACMActivitiesViewController ()<ORKTaskViewControllerDelegate>
@property (nonatomic, nullable) ORKTaskResult *surveyResult;
@end

@implementation ACMActivitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACMSurveyViewController *surveyVC = [[ACMSurveyViewController alloc] init];
    surveyVC.delegate = self;

    [self presentViewController:surveyVC animated:YES completion:nil];
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
            NSLog(@"Survey Discarded");
            break;
        case ORKTaskViewControllerFinishReasonFailed:
            NSLog(@"Survey Failed");
            break;
        case ORKTaskViewControllerFinishReasonSaved:
            NSLog(@"Survey Saved");
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

    [self.surveyResult cm_saveWithCompletion:^(NSString * _Nullable uploadStatus, NSError * _Nullable error) {
        if(nil == uploadStatus) {
            NSLog(@"Survey upload failed: %@", error.localizedDescription);
            return;
        }

        NSLog(@"Survery result upload succeeded with status: %@", uploadStatus);
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
