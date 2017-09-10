//
//  WarehousePurchaseInfo.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/8.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehousePurchaseInfo.h"

@implementation WarehousePurchaseInfo
+(WarehousePurchaseInfo *)from:(NSDictionary *)info
{
    WarehousePurchaseInfo *ret = [[WarehousePurchaseInfo alloc]init];
    ret.m_expressCompany = [info stringWithFilted:@"expresscompany"];
    ret.m_expressCost = [info stringWithFilted:@"expresscost"];
    ret.m_expressPayType = [info stringWithFilted:@"expresscostpaytype"];
    ret.m_expressSerialId = [info stringWithFilted:@"expressserialid"];

    NSArray *arr = info[@"goods"];
    NSMutableArray *goods = [NSMutableArray array];
    for(NSDictionary *_good in arr){
        [goods addObject:[WareHouseGoods from:_good]];
    }
    ret.m_arrGoods = goods;

    ret.m_payType = [info stringWithFilted:@"paytype"];
    ret.m_rejectReason = [info stringWithFilted:@"rejectreason"];
    ret.m_remark = [info stringWithFilted:@"remark"];
    ret.m_state = [info stringWithFilted:@"state"];
    ret.m_expressCompany = [info stringWithFilted:@"expresscompany"];
    ret.m_supplier = info[@"supplier"];
    ret.m_time = [info stringWithFilted:@"timestamp"];
    return ret;
}
@end
