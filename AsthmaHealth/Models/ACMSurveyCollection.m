#import "ACMSurveyCollection.h"
#import "ACMSurveyMetaData.h"

@interface ACMSurveyCollection ()
@property (nonatomic, nonnull) NSArray<ACMSurveyMetaData *> *surveyList;
@end

@implementation ACMSurveyCollection

- (instancetype)init
{
    self = [super init];
    if (nil == self) return nil;

    self.surveyList = @[ [[ACMSurveyMetaData alloc] initWithName:NSLocalizedString(@"About You", nil)
                                                      identifier:@"ACMAboutYouSurveyTask"
                                                andQuestionCount:@8]
                       ];

    return self;
}

- (NSInteger)count
{
    return self.surveyList.count;
}

- (ACMSurveyMetaData *_Nonnull)metaDataForSurveyAtIndex:(NSInteger)index
{
    NSAssert(index >= 0 && index < self.count, @"ACMSurveyCollection: Illegal index");
    return self.surveyList[index];
}

@end
