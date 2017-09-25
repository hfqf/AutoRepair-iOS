//
//  WareHouseGoods.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/28.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WareHouseGoods.h"

@implementation WareHouseGoods
+(WareHouseGoods *)from:(NSDictionary *)info{
    WareHouseGoods *ret = [[WareHouseGoods alloc]init];
    ret.m_id = info[@"_id"];
    ret.m_applycartype = info[@"applycartype"];
    ret.m_barcode = info[@"barcode"];
    ret.m_brand = info[@"brand"];
    ret.m_category = info[@"category"];
    ret.m_costprice = info[@"costprice"];
    ret.m_goodsencode = info[@"goodsencode"];
    ret.m_isactive = info[@"isactive"];

    NSString *minnum = [info stringWithFilted:@"minnum"];
    ret.m_minnum = minnum.length == 0 ? @"0" : minnum;
    
    ret.m_name = [info stringWithFilted:@"name"];
    ret.m_picurl = info[@"picurl"];
    ret.m_productertype = info[@"productertype"];
    ret.m_producteraddress = info[@"producteraddress"];
    ret.m_remark = info[@"remark"];
    ret.m_saleprice = info[@"saleprice"];
    ret.m_subtype = info[@"subtype"];
    ret.m_unit = info[@"unit"];

    NSString *_num = [info stringWithFilted:@"num"];
    ret.m_num = _num.length == 0 ? @"0" : _num;

    NSString *purchasenum = [info stringWithFilted:@"purchasenum"];
    ret.m_purchaseNum = purchasenum.length == 0 ? @"0" : purchasenum;

    if([info[@"position"] isKindOfClass:[NSString class]]){
        ret.m_storePosition = nil;
    }else{
        ret.m_storePosition = info[@"position"];
    }


    NSString *systemPrice = [info stringWithFilted:@"systemprice"];
    ret.m_systemPrice = systemPrice;
    ret.m_owner = [info stringWithFilted:@"owner"];
    return ret;
}
@end
