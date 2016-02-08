#import "ACMMainPanelViewController.h"
#import "ORKResult+CloudMine.h"
#import "NSDate+ACM.h"

@interface ACMMainPanelViewController ()
@property (nonatomic, nullable) UIView *loadingOverlay;
@property (nonatomic, nullable, readwrite) ORKTaskResult *consentResult;
@property (nonatomic, nullable, readwrite) NSArray <ORKTaskResult *> *surveyResults;
@end

@implementation ACMMainPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loadingOverlay = [ACMMainPanelViewController loadingIndicatorWithFrame:self.view.frame];
    [self refreshData];
}

- (void)refreshData
{
    [self showLoading:YES];

    [ORKTaskResult cm_fetchUserResultsWithCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
        [self showLoading:NO];

        if (nil == results) { // TODO: real error handling
            NSLog(@"%@", error.localizedDescription);
            return;
        }

        self.consentResult = (ORKTaskResult *)[ACMMainPanelViewController resultsWithIdentifier:@"ACMParticipantConsentTask" fromResults:results].firstObject;

        NSMutableArray *mutableResults = [results mutableCopy];
        [mutableResults removeObject:self.consentResult];
        self.surveyResults = [mutableResults copy];

        [NSNotificationCenter.defaultCenter postNotificationName:ACMSurveyDataNotification object:self];
    }];
}

- (void)uploadResult:(ORKResult *_Nonnull)surveyResult;
{
    [self showLoading:YES];

    [surveyResult cm_saveWithCompletion:^(NSString * _Nullable uploadStatus, NSError * _Nullable error) {
        if (nil == uploadStatus) {
            // TODO: reall error handling
            NSLog(@"Survey upload failed: %@", error.localizedDescription);
            return;
        }

        [self refreshData];
        NSLog(@"Survery result upload succeeded with status: %@", uploadStatus);
    }];
}

- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier
{
    return [ACMMainPanelViewController resultsWithIdentifier:identifier fromResults:self.surveyResults].count;
}

- (NSInteger)countOfSurveyResultsWithIdentifier:(NSString *_Nonnull)identifier onCalendarDay:(NSDate *_Nonnull)day
{
    NSArray<ORKResult *> *surveyResults = [ACMMainPanelViewController resultsWithIdentifier:identifier fromResults:self.surveyResults];
    NSMutableArray *surveyResultsOnDay = [NSMutableArray new];

    for (ORKResult *result in surveyResults) {
        if (result.endDate.isToday) {
            [surveyResultsOnDay addObject:result];
        }
    }

    return surveyResultsOnDay.count;
}

#pragma mark Private
- (void)showLoading:(BOOL)isLoading
{
    if (isLoading && [self.loadingOverlay isDescendantOfView:self.view]) { // already showing
        return;
    }

    if (!isLoading && ![self.loadingOverlay isDescendantOfView:self.view]) { // already not showing
        return;
    }

    if([NSOperationQueue currentQueue] != [NSOperationQueue mainQueue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _showLoading:isLoading];
        });
    } else {
        [self _showLoading:isLoading];
    }
}

- (void)_showLoading:(BOOL)isLoading
{
    if (isLoading) {
        [UIApplication.sharedApplication beginIgnoringInteractionEvents];
        [self.view addSubview:self.loadingOverlay];
    } else {
        [UIApplication.sharedApplication endIgnoringInteractionEvents];
        [self.loadingOverlay removeFromSuperview];
    }
}

+ (UIView *_Nonnull)loadingIndicatorWithFrame:(CGRect)frame
{
    UIView *loadingOverlay = [[UIView alloc] initWithFrame:frame];
    loadingOverlay.backgroundColor = [UIColor blackColor];
    loadingOverlay.alpha = 0.2f;

    CGRect indicatorFrame = CGRectMake(loadingOverlay.center.x - 37.0f/2.0f, loadingOverlay.center.y - 37.0f/2.0f, 37.0f, 37.0f);
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:indicatorFrame];
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [loadingIndicator startAnimating];

    [loadingOverlay addSubview:loadingIndicator];
    return loadingOverlay;
}

+ (NSArray<ORKResult *> *_Nonnull)resultsWithIdentifier:(NSString *_Nonnull)identifier fromResults:(NSArray<ORKResult *> *_Nullable)fullResults
{
    if (nil == fullResults) {
        return @[];
    }

    NSMutableArray *mutableFilteredResults = [NSMutableArray new];

    for (ORKResult *aResult in fullResults) {
        if (![aResult.identifier isEqualToString:identifier]) {
            continue;
        }

        [mutableFilteredResults addObject:aResult];
    }

    return [mutableFilteredResults copy];
}

@end
