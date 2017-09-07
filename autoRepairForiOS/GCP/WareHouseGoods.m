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
    NSArray *arr = info[@"category"];
    if(arr.count > 0){
        ret.m_category =  [arr firstObject];
    }
    ret.m_costprice = info[@"costprice"];
    ret.m_goodsencode = info[@"goodsencode"];
    ret.m_isactive = info[@"isactive"];
    ret.m_minnum = info[@"minnum"];
    ret.m_name = info[@"name"];
    ret.m_picurl = info[@"picurl"];
    ret.m_productertype = info[@"productertype"];
    ret.m_producteraddress = info[@"producteraddress"];
    ret.m_remark = info[@"remark"];
    ret.m_saleprice = info[@"saleprice"];
    ret.m_subtype = info[@"subtype"];
    ret.m_unit = info[@"unit"];
    return ret;
}
@end
