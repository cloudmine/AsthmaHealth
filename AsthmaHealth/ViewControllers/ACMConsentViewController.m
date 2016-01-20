#import "ACMConsentViewController.h"
#import "ACMConsentDocument.h"

@interface ACMConsentViewController ()

@end

@implementation ACMConsentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    ACMConsentDocument *consentDoc = [ACMConsentDocument new];

    ORKVisualConsentStep *consentStep = [[ORKVisualConsentStep alloc] initWithIdentifier:@"Constent Step Id" document:consentDoc];
    ORKOrderedTask *consentTask = [[ORKOrderedTask alloc] initWithIdentifier:@"Identifier" steps:@[consentStep]];

    self.task = consentTask;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
