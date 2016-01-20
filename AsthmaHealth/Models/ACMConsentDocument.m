#import "ACMConsentDocument.h"

static NSString *const ACMSignatureIdentifier = @"ACMConsentParticipantConsentSignature";

@implementation ACMConsentDocument

// TODO: Ponder, is a subclass actually neccessary?
- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    self.sections = ACMConsentDocument.sections;

    ORKConsentSignature *signature = [ORKConsentSignature signatureForPersonWithTitle:nil dateFormatString:nil identifier:ACMSignatureIdentifier];
    [self addSignature:signature];

    return self;
}

#pragma mark Static Private Helpers

+ (NSArray<ORKConsentSection *> *)sections
{
    return @[self.overviewSection];
}

+ (ORKConsentSection *)sectionWithType:(ORKConsentSectionType)type withSummary:(NSString *)summary andContent:(NSString *)content
{
    ORKConsentSection *section = [[ORKConsentSection alloc] initWithType:type];
    section.summary = summary;
    section.content = content;

    return section;
}

+ (ORKConsentSection *)overviewSection
{
    return [self sectionWithType:ORKConsentSectionTypeOverview
                     withSummary:NSLocalizedString(@"This is the Summary", nil)
                      andContent:NSLocalizedString(@"This is the content of the overview section. Things will happen", nil)];
}

@end
