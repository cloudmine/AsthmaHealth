#import "ACMActivitiesViewController.h"
#import <ResearchKit/ResearchKit.h>
#import <CMHealth/CMHealth.h>
#import "ACMSurveyCollection.h"
#import "ACMSurveyMetaData.h"
#import "ACMSurveyFactory.h"
#import "ACMActivityCell.h"
#import "UIViewController+ACM.h"
#import "ACMMainPanelViewController.h"

@interface ACMActivitiesViewController ()<ORKTaskViewControllerDelegate>
@property (nonatomic, nonnull) ACMSurveyCollection *surveys;
@end

@implementation ACMActivitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

    __weak typeof(self) weakSelf = self;
    [NSNotificationCenter.defaultCenter addObserverForName:ACMSurveyDataNotification
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.tableView reloadData];
    }];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark Target-Action
- (void)refresh:(UIRefreshControl *)sender
{
    [sender endRefreshing];
    [self.acm_mainPanel refreshData];
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
    [cell displayAsCompleted:[self completedSurvey:surveyData]];

    return cell;
}

- (BOOL)completedSurvey:(ACMSurveyMetaData *_Nonnull)surveyData
{
    switch (surveyData.frequency) {
        case ACMSurveyFrequencyOnce:
            return 0 < [self.acm_mainPanel countOfSurveyResultsWithIdentifier:surveyData.rkIdentifier];
        case ACMSurveyFrequencyDaily:
            return 0 < [self.acm_mainPanel countOfSurveyResultsWithIdentifier:surveyData.rkIdentifier onCalendarDay:[NSDate new]];
        default:
            return NO;
    }
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
    
    ORKTaskResult *result = ((ORKTaskViewController *)self.presentedViewController).result;
    [self.acm_mainPanel uploadResult:result];

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
