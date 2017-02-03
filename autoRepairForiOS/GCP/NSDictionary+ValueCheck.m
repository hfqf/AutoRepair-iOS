//
//  NSDictionary+ValueCheck.m
//  xxt_xj
//
//  Created by Points on 14-4-19.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "NSDictionary+ValueCheck.h"

@implementation NSDictionary(valueCheck)
-(NSString *)stringWithFilted:(NSString *)key
{
    id obj = [self objectForKey:key];
    if([obj isKindOfClass:[NSNull class]])
    {
        obj = @"";
    }
    return obj;
}
@end
