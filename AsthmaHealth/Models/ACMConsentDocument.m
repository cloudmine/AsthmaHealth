#import "ACMConsentDocument.h"

@implementation ACMConsentDocument

- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    ORKConsentSection *overviewSection = [[ORKConsentSection alloc] initWithType:ORKConsentSectionTypeOverview];
    overviewSection.summary = NSLocalizedString(@"This is the Summary", nil);
    overviewSection.content = NSLocalizedString(@"This is the content of the overview section. Things will happen", nil);

    self.sections = @[ overviewSection ];

    return self;
}

@end
