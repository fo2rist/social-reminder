

#import <Foundation/Foundation.h>

@interface NSDate (INOHelpers)

@property (nonatomic, readonly) NSCalendar *calendar;

- (NSDate *)clippedDateWithCalendarUnits:(NSCalendarUnit)calendarUnit;

- (NSDate *)dateByAddingValue:(NSUInteger)value forDateKey:(NSString *)key;

- (NSUInteger)daysInMonth;

- (NSUInteger)dayOfWeek;

- (NSDate *)beginningOfDay;
- (NSDate *)endOfDay;

- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;

- (NSDate *)beginningOfYear;
- (NSDate *)endOfYear;

@end
