//
//  WarehouseSupplierInfo.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseSupplierInfo.h"

@implementation WarehouseSupplierInfo

+(WarehouseSupplierInfo *)from:(NSDictionary *)info
{
    WarehouseSupplierInfo *ret= [[WarehouseSupplierInfo alloc]init];
    ret.m_id = [info stringWithFilted:@"_id"];
    ret.m_address = [info stringWithFilted:@"address"];
    ret.m_managerName = [info stringWithFilted:@"managername"];
    ret.m_remark = [info stringWithFilted:@"remark"];
    ret.m_companyName = [info stringWithFilted:@"suppliercompanyname"];
    ret.m_tel = [info stringWithFilted:@"tel"];
    ret.m_owner = [info stringWithFilted:@"owner"];
    return ret;
}

@end
