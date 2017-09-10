//
//  WarehouseSupplierInfo.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarehouseSupplierInfo : NSObject
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_address;
@property(nonatomic,strong)NSString *m_managerName;
@property(nonatomic,strong)NSString *m_remark;
@property(nonatomic,strong)NSString *m_companyName;
@property(nonatomic,strong)NSString *m_tel;
@property(nonatomic,strong)NSString *m_owner;
@property(assign)BOOL  m_isSelected;
+(WarehouseSupplierInfo *)from:(NSDictionary *)info;
@end
