//
//  ADTRepairInfo.m
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "ADTRepairInfo.h"

@implementation ADTRepairInfo
+ (ADTRepairInfo *)from:(NSDictionary *)info
{
    ADTRepairInfo *newRep = [[ADTRepairInfo alloc]init];
    newRep.m_more = info[@"addition"];
    newRep.m_carCode = info[@"carcode"];
    newRep.m_repairCircle = info[@"circle"];
    newRep.m_isClose = [info[@"isclose"]integerValue] == 0;
    newRep.m_owner = info[@"owner"];
    newRep.m_time = info[@"repairetime"];
    newRep.m_repairType = info[@"repairtype"];
    newRep.m_owner = info[@"owner"];
    newRep.m_targetDate = info[@"tipcircle"];
    newRep.m_km = info[@"totalkm"];
    newRep.m_idFromNode = info[@"_id"];
    newRep.m_insertTime = info[@"inserttime"];
    
    NSArray *arr = info[@"items"];
    NSInteger total = 0;
    
    if([arr isKindOfClass:[NSArray class]])
    {
        NSMutableArray *_insertArr = [NSMutableArray array];
        for(NSDictionary *itemInfo in arr){
            ADTRepairItemInfo *item = [ADTRepairItemInfo from:itemInfo];
            [_insertArr addObject:item];
            total+=item.m_currentPrice;
        }
        newRep.m_arrRepairItem = _insertArr;
    }
    newRep.m_totalPrice = total;
    return newRep;
}
@end
