//
//  ADTRepairInfo.m
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "ADTRepairInfo.h"
#import "NSDictionary+ValueCheck.h"
@implementation ADTRepairInfo
+ (ADTRepairInfo *)from:(NSDictionary *)info
{
    ADTRepairInfo *newRep = [[ADTRepairInfo alloc]init];
    newRep.m_more = info[@"addition"];
    newRep.m_carCode = info[@"carcode"];
    newRep.m_repairCircle = info[@"circle"];
    newRep.m_isClose = [info[@"isclose"]integerValue] == 1;
    newRep.m_isreaded = [info[@"isreaded"]integerValue] == 1;
    newRep.m_owner = info[@"owner"];
    newRep.m_time = info[@"repairetime"];
    newRep.m_repairType = info[@"repairtype"];
    newRep.m_owner = info[@"owner"];
    newRep.m_targetDate = info[@"tipcircle"];
    newRep.m_km = info[@"totalkm"];
    newRep.m_idFromNode = info[@"_id"];
    newRep.m_insertTime = info[@"inserttime"];
    
    newRep.m_entershoptime = [info stringWithFilted:@"entershoptime"];
    newRep.m_state = [info stringWithFilted:@"state"].length == 0? @"0" : [info stringWithFilted:@"state"];
    newRep.m_wantedcompletedtime = [info stringWithFilted:@"wantedcompletedtime"];
    newRep.m_customremark = [info stringWithFilted:@"customremark"];
    newRep.m_iswatiinginshop = [info stringWithFilted:@"iswatiinginshop"].length == 0? @"0" : [info stringWithFilted:@"iswatiinginshop"];
    newRep.m_contactid = [info stringWithFilted:@"contactid"];

    newRep.m_ownMoney = [info stringWithFilted:@"ownnum"];

    NSArray *arr = info[@"items"];
    NSInteger total = 0;
    NSMutableArray *_insertArr = [NSMutableArray array];

    if([arr isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *itemInfo in arr){
            ADTRepairItemInfo *item = [ADTRepairItemInfo from:itemInfo];
            [_insertArr addObject:item];
            total+=item.m_currentPrice;
        }
    }
    newRep.m_arrRepairItem = _insertArr;

    newRep.m_totalPrice = total;
    newRep.m_isAddNewRepair = NO;
    return newRep;
}


+ (ADTRepairInfo *)initWith:(ADTContacterInfo *)contact
{
    ADTRepairInfo *newRep = [[ADTRepairInfo alloc]init];
    newRep.m_more = @"";
    newRep.m_carCode = contact.m_carCode;
    newRep.m_contactid = contact.m_idFromServer;
    newRep.m_repairCircle = @"";
    newRep.m_isClose = NO;
    newRep.m_isreaded = NO;
    newRep.m_time = @"";
    newRep.m_repairType = @"";
    newRep.m_owner = [LoginUserUtil userTel];
    newRep.m_targetDate = @"";
    newRep.m_km = @"";
    newRep.m_idFromNode = @"";
    newRep.m_insertTime = @"";
    newRep.m_entershoptime = [LocalTimeUtil getCurrentTime];
    newRep.m_state = @"0";
    newRep.m_wantedcompletedtime = @"";
    newRep.m_customremark = @"";
    newRep.m_iswatiinginshop = @"0";
    newRep.m_arrRepairItem = [[NSMutableArray alloc]init];
    newRep.m_totalPrice = 0;
    newRep.m_isAddNewRepair = YES;
    return newRep;
}

- (void)updateTotalPrice
{
    NSInteger total = 0;
    NSMutableArray *_insertArr = [NSMutableArray array];
    for(ADTRepairItemInfo *item in self.m_arrRepairItem){
        [_insertArr addObject:item];
        total+=item.m_currentPrice;
    }
    self.m_totalPrice = total;
}
@end
