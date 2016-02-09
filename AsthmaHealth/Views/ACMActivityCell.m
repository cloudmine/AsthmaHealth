#import "ACMActivityCell.h"
#import "ACMSurveyMetaData.h"
#import "UIColor+ACM.h"

@interface ACMActivityCell ()
@property (weak, nonatomic) IBOutlet UIView *frequencyIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *completionImage;
@end

@implementation ACMActivityCell

- (void)configureWithMetaData:(ACMSurveyMetaData *_Nonnull)metaData
{
    self.nameLabel.text = metaData.displayName;
    self.questionCountLabel.text = [NSString localizedStringWithFormat:@"%@ Questions", metaData.questionCount.stringValue];
    self.frequencyIndicator.backgroundColor = [ACMActivityCell colorForFrequency:metaData.frequency];
}

- (void)displayAsCompleted:(BOOL)isCompleted
{
    self.completionImage.layer.borderWidth = 1.0f;
    self.completionImage.layer.cornerRadius = self.completionImage.bounds.size.height / 2.0f;
    self.userInteractionEnabled = !isCompleted;

    if (isCompleted) {
        self.completionImage.layer.borderColor = [UIColor clearColor].CGColor;
        self.completionImage.image = [UIImage imageNamed:@"CheckMark"];
    } else {
        self.completionImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.completionImage.image = nil;
    }
}

+ (UIColor *_Nonnull)colorForFrequency:(ACMSurveyFrequency)frequency
{
    switch (frequency) {
        case ACMSurveyFrequencyOnce:
            return [UIColor acmOnceColor];
        case ACMSurveyFrequencyDaily:
            return[UIColor acmDailyColor];
        default:
            return [UIColor clearColor];
    }
}

@end
