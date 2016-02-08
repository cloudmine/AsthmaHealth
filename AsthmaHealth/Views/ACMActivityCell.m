#import "ACMActivityCell.h"
#import "ACMSurveyMetaData.h"

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

    self.completionImage.image = nil;
    self.completionImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.completionImage.layer.borderWidth = 1.0f;
    self.completionImage.layer.cornerRadius = self.completionImage.bounds.size.height / 2.0f;
}

+ (UIColor *_Nonnull)colorForFrequency:(ACMSurveyFrequency)frequency
{
    switch (frequency) {
        case ACMSurveyFrequencyOnce:
            return [ACMActivityCell onceColor];
        case ACMSurveyFrequencyDaily:
            return[ACMActivityCell dailyColor];
        default:
            return [UIColor clearColor];
    }
}

+ (UIColor *_Nonnull)onceColor
{
    return [UIColor colorWithRed:141.0f/255.0f green:53.0f/255.0f blue:206.0f/255.0f alpha:1.0f];
}


+ (UIColor *_Nonnull)dailyColor
{
    return [UIColor colorWithRed:35.0f/255.0f green:204.0f/255.0f blue:104.0f/255.0f alpha:1.0f];
}
@end
