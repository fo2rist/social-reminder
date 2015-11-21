
#import "NSDate+Helpers.h"

@implementation NSDate (INOHelpers)

- (NSCalendar *)calendar {
    return [NSCalendar currentCalendar];
}

- (NSDate *)clippedDateWithCalendarUnits:(NSCalendarUnit)calendarUnit {
    NSDateComponents *components = [self.calendar components:calendarUnit fromDate:self];
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)dateByAddingValue:(NSUInteger)value forDateKey:(NSString *)key {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setValue:@(value) forKey:key];
    return [self.calendar dateByAddingComponents:dateComponents toDate:self options:0];
}

- (NSUInteger)daysInMonth {
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSUInteger)dayOfWeek {
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitWeekOfMonth fromDate:self];
    return ([dateComponents weekday] - [self.calendar firstWeekday]) % 7;
}

- (NSDate *)beginningOfDay {
    return [self clippedDateWithCalendarUnits:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay];
}

- (NSDate *)endOfDay {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    return [[self.calendar dateByAddingComponents:components toDate:[self beginningOfDay] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *)beginningOfMonth {
    return [self clippedDateWithCalendarUnits:NSCalendarUnitYear | NSCalendarUnitMonth];
}

- (NSDate *)endOfMonth {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    return [[self.calendar dateByAddingComponents:components toDate:[self beginningOfMonth] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *)beginningOfYear {
    return [self clippedDateWithCalendarUnits:NSCalendarUnitYear];
}

- (NSDate *)endOfYear {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:1];
    return [[self.calendar dateByAddingComponents:components toDate:[self beginningOfYear] options:0] dateByAddingTimeInterval:-1];
}

+ (NSDate *)dateWithDate:(NSDate *)date time:(NSDate *)time; {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned unitFlagsDate = NSCalendarUnitYear | NSCalendarUnitMonth
    |  NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate
                                                    fromDate:date];
    unsigned unitFlagsTime = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime
                                                    fromDate:time];
    
    [dateComponents setSecond:0];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];
    
    return combDate;
}

@end
