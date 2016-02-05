#import "ACMDashSurveysViewController.h"

@interface ACMDashSurveysViewController ()

@end

@implementation ACMDashSurveysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.surveyResults);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SurveyDetailCell" forIndexPath:indexPath];
    return cell;
}

@end
