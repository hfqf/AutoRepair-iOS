//
//  ReachabilityObserver.m
//  JZH_Test
//
//  Created by Points on 13-10-23.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "ReachabilityObserver.h"
#import "Reachability.h"
@implementation ReachabilityObserver

+ (BOOL)isCanSendMsg
{
    Reachability *reacheable = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reacheable currentReachabilityStatus];
    if(status == ReachableViaWiFi || status == ReachableViaWWAN)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
