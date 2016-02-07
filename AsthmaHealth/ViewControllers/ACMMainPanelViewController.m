#import "ACMMainPanelViewController.h"
#import "ORKResult+CloudMine.h"

@interface ACMMainPanelViewController ()
@property (nonatomic, nullable, readwrite) ORKTaskResult *consentResult;
@property (nonatomic, nullable, readwrite) NSArray <ORKTaskResult *> *surveyResults;
@end

@implementation ACMMainPanelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];
}

- (void)refreshData
{
    [ORKTaskResult cm_fetchUserResultsWithCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
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
