//
//  ADTRepairItemInfo.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ADTRepairItemInfo.h"

@implementation ADTRepairItemInfo
+ (ADTRepairItemInfo *)from:(NSDictionary *)info
{
    ADTRepairItemInfo *item = [[ADTRepairItemInfo alloc]init];
    item.m_repid = info[@"repid"];
    item.m_contactid = info[@"contactid"];
    item.m_price = info[@"price"];
    item.m_num = info[@"num"];
    item.m_type = info[@"type"];
    item.m_id = info[@"_id"];
    item.m_currentPrice = [item.m_price integerValue]* [item.m_num integerValue];
    item.m_goodsId = [info stringWithFilted:@"goods"];
    item.m_serviceId = [info stringWithFilted:@"service"];
    item.m_itemType = [info stringWithFilted:@"itemtype"];

    return item;
}
@end
