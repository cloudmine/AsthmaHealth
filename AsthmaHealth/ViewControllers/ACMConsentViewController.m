#import "ACMConsentViewController.h"

@interface ACMConsentViewController ()

@end

@implementation ACMConsentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (nil == self) return nil;

    ORKConsentSection *overviewSection = [[ORKConsentSection alloc] initWithType:ORKConsentSectionTypeOverview];
    overviewSection.summary = NSLocalizedString(@"This is the Summary", nil);
    overviewSection.content = NSLocalizedString(@"This is the content of the overview section. Things will happen", nil);

    ORKConsentDocument *consentDoc = [ORKConsentDocument new];
    consentDoc.sections = @[ overviewSection ];

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
