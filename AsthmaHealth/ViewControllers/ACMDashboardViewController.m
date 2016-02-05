#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"
#import "ORKResult+CloudMine.h"

@interface ACMDashboardViewController ()
@property (nonatomic, nullable) ORKTaskResult *consentResult;
@property (nonatomic, nullable) NSArray <ORKTaskResult *> *surveyResults;
@property (weak, nonatomic) IBOutlet UILabel *consentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *surveyCountLabel;
@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // TODO: Loading status

    [self resetUI];
    [self fetchData];
}

- (void)resetUI
{
    self.consentDateLabel.text = @"";
    self.surveyCountLabel.text = @"";
}

- (void)refreshUI
{
    NSString *consentDate = [ACMDashboardViewController consentDateStringForDate:self.consentResult.endDate];
    NSString *surveyCount = [NSString stringWithFormat:@"%li", (long)self.surveyResults.count];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.consentDateLabel.text = consentDate;
        self.surveyCountLabel.text = surveyCount;
    });
}

- (void)fetchData
{
    [ORKTaskResult cm_fetchUserResultsWithCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if (nil == results) { // TODO: real error handling
            NSLog(@"%@", error.localizedDescription);
            return;
        }

        self.consentResult = (ORKTaskResult *)[ACMDashboardViewController resultsWithIdentifier:@"ACMParticipantConsentTask" fromResults:results].firstObject;

        NSMutableArray *mutableResults = [results mutableCopy];
        [mutableResults removeObject:self.consentResult];
        self.surveyResults = [mutableResults copy];

        [self refreshUI];
    }];
}

#pragma mark Target-Action
- (IBAction)refreshButtonDidPress:(UIButton *)sender
{
    [self fetchData];
}

#pragma mark Presentation
+ (NSString *_Nonnull)consentDateStringForDate:(NSDate *_Nullable)date
{
    if (nil == date) {
        return @"Never";
    }

    //TODO: Real date formatting
    return [NSString stringWithFormat:@"%@", date];
}

#pragma mark Private

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
