//
//  NSDate+Util.m
//  JSLite
//
//  Created by ZhangLi on 8/4/13.
//  Copyright (c) 2013 ZhangLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

- (NSString *)getFormatYearMonthDay;
- (int )getWeekNumOfMonth;
- (int )getWeekOfYear;
- (NSDate *)dateAfterDay:(int)day;
- (NSDate *)dateafterMonth:(int)month;
- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;
- (int )getHour;
- (int)getMinute;
- (int )getHour:(NSDate *)date;
- (int)getMinute:(NSDate *)date;
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)string;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;
- (NSDate *)endOfWeek;
+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;
+ (NSString *)getCurrentTime;
+ (NSString *)getTomorrowTime;
+ (NSString *)getCurrentDateTime;
+ (NSString *)getYesterdayTime;
+ (NSString *)getCurrentDate;
+ (NSString *)getYesterdayDate;
+ (NSString *)dateWithFormatTodayOrYesterday:(NSString *)date;
+ (BOOL) compareDate:(NSString*) date otherDate:(NSString*)otherDate;
+ (NSString *)stringMonthAndDayFromDate:(NSDate *)date;
+ (NSString *)weekDayWithIndex:(NSString *)strIndex;
@end
