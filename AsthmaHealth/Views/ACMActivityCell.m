#import "ACMActivityCell.h"
#import "ACMSurveyMetaData.h"

@interface ACMActivityCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;
@end

@implementation ACMActivityCell

- (void)configureWithMetaData:(ACMSurveyMetaData *_Nonnull)metaData
{
    self.nameLabel.text = metaData.displayName;
    self.questionCountLabel.text = [NSString localizedStringWithFormat:@"%@ Questions", metaData.questionCount.stringValue];
}

@end
