#import "ACMDashSurveysViewController.h"
#import "ACMMainPanelViewController.h"
#import "UIViewController+ACM.h"

@interface ACMDashSurveysViewController ()
@property (nonatomic, nonnull) NSDictionary<NSString *, NSNumber *> *surveyCounts;
@end

@implementation ACMDashSurveysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.surveyCounts = [ACMDashSurveysViewController surveyCountsForResults:self.acm_mainPanel.surveyResults];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.surveyCounts.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyDetailCell" forIndexPath:indexPath];

    NSArray *sortedKeys = [self.surveyCounts.allKeys sortedArrayUsingSelector:@selector(compare:)];
    cell.textLabel.text = sortedKeys[indexPath.row];
    cell.detailTextLabel.text = self.surveyCounts[sortedKeys[indexPath.row]].stringValue;

    return cell;
}

#pragma mark Getters-Setters
- (NSDictionary<NSString *,NSNumber *> *)surveyCounts
{
    if (nil == _surveyCounts) {
        _surveyCounts = @{ };
    }

    return _surveyCounts;
}

#pragma mark Private
+ (NSDictionary<NSString *, NSNumber *> *_Nonnull)surveyCountsForResults:(NSArray<ORKTaskResult *> *_Nullable)results
{
    if (nil == results) {
        return @{ };
    }

    NSMutableDictionary *mutableCounts = [NSMutableDictionary new];

    for (ORKTaskResult *aResult in results) {
        NSNumber *currentCount = [mutableCounts objectForKey:aResult.identifier];

        if (nil == currentCount) {
            [mutableCounts setObject:@1 forKey:aResult.identifier];
        } else {
            NSNumber *incrementedCount = [NSNumber numberWithInteger:currentCount.integerValue + 1];
            [mutableCounts setObject:incrementedCount forKey:aResult.identifier];
        }
    }

    return [mutableCounts copy];
}

@end
