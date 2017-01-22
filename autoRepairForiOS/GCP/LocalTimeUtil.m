//
//  LocalTimeUtil.m
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "LocalTimeUtil.h"

@implementation LocalTimeUtil


+ (BOOL)isTodayWith:(NSString *)dayTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    
    return [strDate isEqualToString:dayTime];
}

+ (NSString *)getCurrentTime
{
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}

+ (BOOL)isToday:(NSString *)time
{
    NSString * todatTime = [self getCurrentTime];
    NSString * compareTime = [time substringToIndex:10];
    NSString * currentTime = [todatTime substringToIndex:10];
    return ([compareTime isEqualToString:currentTime]) ? YES : NO;
}

+ (BOOL)isYesterday:(NSString *)time
{
    NSString * todatTime = [self getCurrentTime];
    NSString * comYM = [time substringToIndex:7];
    NSString *currentYM = [time substringToIndex:7];
    
    if([comYM isEqualToString: currentYM])
    {
        NSString * compareTime = [time substringWithRange:NSMakeRange(8, 2)];
        NSString * currentTime = [todatTime substringWithRange:NSMakeRange(8, 2)];
        if([compareTime intValue]+1 == [currentTime intValue])
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getCurrentMonth
{
    NSString *year_ = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SELECTED_YEAR];
    NSString *month_ = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_SELECTED_MONTH];

    if(year_ && month_)
    {
        return [NSString stringWithFormat:@"%@%@",year_,month_];
    }
    NSDate *dateToDay = [NSDate date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMM"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    return strDate;
}

+ (NSString *)getLocalTimeWith:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

@end
