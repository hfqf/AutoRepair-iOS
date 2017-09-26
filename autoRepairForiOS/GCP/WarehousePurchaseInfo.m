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
    ret.m_id = [info stringWithFilted:@"_id"];
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
    NSDictionary *supplier = info[@"supplier"];
    if([supplier isKindOfClass:[NSNull class]]){

    }else{
        ret.m_supplier = info[@"supplier"];
        ret.m_supplierInfo = [WarehouseSupplierInfo from:info[@"supplier"]];
    }

    ret.m_time = [info stringWithFilted:@"timestamp"];
    ret.m_time2 = [info stringWithFilted:@"timestamp2"];
    ret.m_time3 = [info stringWithFilted:@"timestamp3"];
    ret.m_buyer = info[@"buyer"];
    ret.m_rejecter = info[@"rejecter"];
    ret.m_saver = info[@"saver"];
    ret.m_rejectReason = [info stringWithFilted:@"rejectreason"];
    ret.m_price = [info stringWithFilted:@"price"];
    ret.m_num = [info stringWithFilted:@"num"];
    return ret;
}
@end
