#import "NSDate+ACM.h"

@implementation NSDate (ACM)

- (BOOL)isToday
{
    NSDate *now = [NSDate new];
    NSTimeInterval firstSecondOfToday = [NSDate startOfDay:now].timeIntervalSince1970;
    NSTimeInterval lastSecondOfToday = [NSDate endOfDay:now].timeIntervalSince1970;

    return self.timeIntervalSince1970 > firstSecondOfToday && self.timeIntervalSince1970 < lastSecondOfToday;
}

+ (NSDate *)startOfDay:(NSDate *)date
{
    NSDateComponents *dateComps = [self localDateCompsForDate:date];

    // First second of day
    dateComps.hour = 0;
    dateComps.minute = 0;
    dateComps.second = 1;

    return [[NSCalendar currentCalendar] dateFromComponents:dateComps];
}

+ (NSDate *)endOfDay:(NSDate *)date
{
    NSDateComponents *dateComps = [self localDateCompsForDate:date];

    // Last second of day
    dateComps.hour = 23;
    dateComps.minute = 59;
    dateComps.second = 59;

    return [[NSCalendar currentCalendar] dateFromComponents:dateComps];
}

+ (NSDateComponents *)localDateCompsForDate:(NSDate *)date
{
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond;
    return [[NSCalendar currentCalendar] components:units fromDate:date];
}

@end
