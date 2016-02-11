#import "UIColor+ACM.h"

@implementation UIColor (ACM)

+ (UIColor *_Nonnull)acmBlueColor
{
    return [UIColor colorWithRed:13.0f/255.0f green:150.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
}

+ (UIColor *_Nonnull)acmOnceColor
{
    return [UIColor colorWithRed:141.0f/255.0f green:53.0f/255.0f blue:206.0f/255.0f alpha:1.0f];
}

+ (UIColor *_Nonnull)acmDailyColor
{
    return [UIColor colorWithRed:35.0f/255.0f green:204.0f/255.0f blue:104.0f/255.0f alpha:1.0f];
}

@end