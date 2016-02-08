#import "ACMActivitiesViewController.h"
#import <ResearchKit/ResearchKit.h>
#import "ORKResult+CloudMine.h"
#import "ACMSurveyCollection.h"
#import "ACMSurveyMetaData.h"
#import "ACMSurveyFactory.h"
#import "ACMActivityCell.h"

@interface ACMActivitiesViewController ()<ORKTaskViewControllerDelegate>
@property (nonatomic, nullable) ORKTaskResult *surveyResult;
@property (nonatomic, nonnull) ACMSurveyCollection *surveys;
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
    return self.surveys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACMSurveyMetaData *surveyData = [self.surveys metaDataForSurveyAtIndex:indexPath.row];

    ACMActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    NSAssert([cell isKindOfClass:[ACMActivityCell class]], @"ACMActivitiesViewController: Expected an ACMActivityCell, but received %@", [cell class]);

    [cell configureWithMetaData:surveyData];
    [cell displayAsCompleted:(indexPath.row % 2 == 0)]; // TODO: actual logic

    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACMSurveyMetaData *surveyData = [self.surveys metaDataForSurveyAtIndex:indexPath.row];
    ORKTaskViewController *surveyVC = [ACMSurveyFactory surveyViewControllerForIdentifier:surveyData.rkIdentifier];
    NSAssert(nil != surveyVC, @"ACMActivitiesViewController: Requested survey with unknown identifier %@", surveyData.rkIdentifier);
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
    NSAssert([self.presentedViewController isKindOfClass:[ORKTaskViewController class]],
             @"Attempted to handle a survey completion when a ACMSurveyViewController was not presented");
    
    self.surveyResult = ((ORKTaskViewController *)self.presentedViewController).result;

    [self.surveyResult cm_saveWithCompletion:^(NSString * _Nullable uploadStatus, NSError * _Nullable error) {
        if(nil == uploadStatus) {
            NSLog(@"Survey upload failed: %@", error.localizedDescription);
            return;
        }

        NSLog(@"Survery result upload succeeded with status: %@", uploadStatus);
    }];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Getter-Setters
- (ACMSurveyCollection *)surveys
{
    if (nil == _surveys) {
        _surveys = [ACMSurveyCollection new];
    }

    return _surveys;
}

@end
