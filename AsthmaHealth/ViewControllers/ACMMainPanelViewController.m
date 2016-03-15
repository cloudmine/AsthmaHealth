#import "ACMMainPanelViewController.h"
#import <CMHealth/CMHealth.h>
#import "NSDate+ACM.h"
#import "UIColor+ACM.h"
#import "ACMAlerter.h"
#import "ACMAppDelegate.h"

@interface ACMMainPanelViewController ()
@property (nonatomic, nullable) UIView *loadingOverlay;
@property (nonatomic, nullable, readwrite) NSArray <ORKTaskResult *> *surveyResults;
@property (nonatomic, nullable, readwrite) ORKTaskResult *todaysDailySurveyResult;
@property (nonatomic, nullable, readwrite) ORKTaskResult *aboutYouSurveyResult;
@property (nonatomic, nullable, readonly) ACMAppDelegate *appDelegate;
@end

@implementation ACMMainPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loadingOverlay = [ACMMainPanelViewController loadingIndicatorWithFrame:self.view.frame];
    self.tabBar.tintColor = [UIColor acmBlueColor];

    [self validateConsentAndFetchData];
}

- (void)validateConsentAndFetchData
{
    [self showLoading:YES];

    [CMHUser.currentUser fetchUserConsentForStudyWithDescriptor:@"ACMHealth" andCompletion:^(CMHConsent * _Nullable consent, NSError * _Nullable error) {
        if (nil != error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Failled to Verify Consent", nil)
                                       andMessage:[NSString localizedStringWithFormat:@"Please try logging in or completing particpant consent; %@", error.localizedDescription]
                                 inViewController:self];

                [self.appDelegate loadOnboarding];
            });

            return;
        }

        if (nil == consent) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ACMAlerter displayAlertWithTitle:NSLocalizedString(@"Consent for study not found", nil)
                                       andMessage:NSLocalizedString(@"Please complete participant consent before proceeding", nil)
                                 inViewController:self];

                [self.appDelegate loadOnboarding];
            });

            return;
        }
        
        [self refreshData];
    }];
}

- (void)refreshData
{
    [self showLoading:YES];

    [ORKTaskResult cmh_fetchUserResultsForStudyWithQuery:@"[identifier = \"ACMAboutYouSurveyTask\"]" withCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if (nil == results) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }

        self.aboutYouSurveyResult = results.firstObject;

        [ORKTaskResult cmh_fetchUserResultsForStudyWithQuery:@"[identifier = \"ACMDailySurveyTask\"]" withCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
            [self showLoading:NO];

            if (nil == results) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }

            self.todaysDailySurveyResult = [ACMMainPanelViewController firstResultFromSurveys:results onCalendarDay:[NSDate new]];

            [NSNotificationCenter.defaultCenter postNotificationName:ACMSurveyDataNotification object:self];
        }];
    }];
}

- (void)uploadResult:(ORKResult *_Nonnull)surveyResult;
{
    [self showLoading:YES];

    [surveyResult cmh_saveToStudyWithDescriptor:nil withCompletion:^(NSString * _Nullable uploadStatus, NSError * _Nullable error) {
        if (nil == uploadStatus) {
            // TODO: reall error handling
            NSLog(@"Survey upload failed: %@", error.localizedDescription);
            return;
        }

        [self refreshData];
        NSLog(@"Survery result upload succeeded with status: %@", uploadStatus);
    }];
}

+ (ORKTaskResult *_Nullable)firstResultFromSurveys:(NSArray<ORKTaskResult *> *_Nonnull)surveyResults onCalendarDay:(NSDate *_Nonnull)day
{
    for (ORKTaskResult *result in surveyResults) {
        if (result.endDate.isToday) {
            return result;
        }
    }

    return nil;
}

#pragma mark Getters-Setters
- (ACMAppDelegate *)appDelegate
{
    ACMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSAssert([appDelegate isKindOfClass:[ACMAppDelegate class]], @"App Delegate is unexpected type: %@", [appDelegate class]);

    return appDelegate;
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
