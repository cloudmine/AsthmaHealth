#import "ACMConsentDocument.h"

static NSString *const ACMSignatureIdentifier = @"ACMConsentParticipantConsentSignature";

@implementation ACMConsentDocument

// TODO: Ponder, is a subclass actually neccessary?
- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    self.htmlReviewContent = ACMConsentDocument.reviewContent;
    self.sections = ACMConsentDocument.sections;

    ORKConsentSignature *signature = [ORKConsentSignature signatureForPersonWithTitle:nil dateFormatString:nil identifier:ACMSignatureIdentifier];
    signature.requiresName = NO;
    [self addSignature:signature];

    return self;
}

#pragma mark Static Private Helpers

+ (NSString *)reviewContent
{
    return NSLocalizedString(@"ACHConsentReviewContent", nil);
}

+ (NSArray<ORKConsentSection *> *)sections
{
    return @[self.welcomeSection,
             self.testSection,
             self.dataSection,
             [ORKConsentSection cmh_sectionForSecureCloudMineDataStorage]];
}

+ (ORKConsentSection *)sectionWithType:(ORKConsentSectionType)type title:(NSString *)title customImage:(UIImage *)customImage summary:(NSString *)summary andContent:(NSString *)content
{
    ORKConsentSection *section = [[ORKConsentSection alloc] initWithType:type];
    section.summary = summary;
    section.content = content;
    if (nil != title) { section.title = title; }
    if (nil != customImage) { section.customImage = customImage; }

    return section;
}

+ (ORKConsentSection *)welcomeSection
{
    return [self sectionWithType:ORKConsentSectionTypeOverview
                           title:nil
                     customImage:nil
                         summary:NSLocalizedString(@"ACHConsentSectionWelcomeSummary", nil)
                      andContent:NSLocalizedString(@"ACHConsentSectionWelcomeContent", nil)];
}

+ (ORKConsentSection *)testSection
{
    return [self sectionWithType:ORKConsentSectionTypeCustom
                           title:NSLocalizedString(@"ACHConsentSectionTestTitle", nil)
                     customImage:nil
                         summary:NSLocalizedString(@"ACHConsentSectionTestSummary", nil)
                      andContent:NSLocalizedString(@"ACHConsentSectionTestContent", nil)];
}

+ (ORKConsentSection *)dataSection
{
    return [self sectionWithType:ORKConsentSectionTypeDataGathering
                           title:nil
                     customImage:nil
                         summary:NSLocalizedString(@"ACHConsentSectionDataSummary", nil)
                      andContent:NSLocalizedString(@"ACHConsentSectionDataContent", nil)];
}

@end
