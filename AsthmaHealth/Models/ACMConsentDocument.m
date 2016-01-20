#import "ACMConsentDocument.h"

static NSString *const ACMSignatureIdentifier = @"ACMConsentParticipantConsentSignature";

@implementation ACMConsentDocument

// TODO: Ponder, is a subclass actually neccessary?
- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    ORKConsentSection *overviewSection = [[ORKConsentSection alloc] initWithType:ORKConsentSectionTypeOverview];
    overviewSection.summary = NSLocalizedString(@"This is the Summary", nil);
    overviewSection.content = NSLocalizedString(@"This is the content of the overview section. Things will happen", nil);

    self.sections = @[ overviewSection ];

    ORKConsentSignature *signature = [ORKConsentSignature signatureForPersonWithTitle:nil dateFormatString:nil identifier:ACMSignatureIdentifier];
    [self addSignature:signature];

    return self;
}

@end
