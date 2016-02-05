#import "ACMDashboardViewController.h"
#import <CloudMine/CloudMine.h>
#import <ResearchKit/ResearchKit.h>
#import "ACMResultWrapper.h"
#import "ORKResult+CloudMine.h"

@interface ACMDashboardViewController ()
@property (nonatomic, nullable) ORKTaskResult *consentResult;
@property (nonatomic, nullable) NSArray <ORKTaskResult *> *surveyResults;
@end

@implementation ACMDashboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [ORKTaskResult cm_fetchUserResultsWithCompletion:^(NSArray * _Nullable results, NSError * _Nullable error) {
        if (nil == results) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }

        ORKResult *possibleConsent = (ORKTaskResult *)[ACMDashboardViewController resultsWithIdentifier:@"ACMParticipantConsentTask" fromResults:results].firstObject;

        NSMutableArray *mutableResults = [results mutableCopy];
        [mutableResults removeObject:self.consentResult];
        self.surveyResults = [mutableResults copy];
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
