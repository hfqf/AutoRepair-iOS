//
//  LocalTimeUtil.h
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalTimeUtil : NSObject

+ (BOOL)isTodayWith:(NSString *)dayTime;

+ (NSString *)getCurrentTime;

+ (NSString *)getCurrentTime2;


+ (BOOL)isToday:(NSString *)time;

+ (BOOL)isYesterday:(NSString *)time;


+ (NSString *)getCurrentMonth;

+ (NSString *)getLocalTimeWith:(NSDate *)date;

+ (NSString *)getLocalTimeWith3:(NSDate *)date;

+ (BOOL)isValid2:(NSString *)beginTime endTime:(NSString *)endTime;
@end
