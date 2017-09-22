//
//  WarehousePurchaseInfo.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/8.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WarehouseSupplierInfo.h"
@interface WarehousePurchaseInfo : NSObject
@property(nonatomic,strong)NSString *m_state;
@property(nonatomic,strong)NSDictionary *m_storePosition;
@property(nonatomic,strong)NSString *m_payType;
@property(nonatomic,strong)NSString *m_expressPayType;
@property(nonatomic,strong)NSString *m_expressCompany;
@property(nonatomic,strong)NSString *m_expressSerialId;
@property(nonatomic,strong)NSString *m_expressCost;
@property(nonatomic,strong)NSDictionary *m_supplier;
@property(nonatomic,strong)WarehouseSupplierInfo *m_supplierInfo;
@property(nonatomic,strong)NSString *m_remark;
@property(nonatomic,strong)NSMutableArray  *m_arrGoods;
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_time;
@property(nonatomic,strong)NSString *m_time2;
@property(nonatomic,strong)NSString *m_time3;
@property(nonatomic,strong)NSString *m_rejectReason;
@property(nonatomic,strong)NSDictionary *m_rejecter;
@property(nonatomic,strong)NSDictionary *m_buyer;
@property(nonatomic,strong)NSDictionary *m_saver;
@property(assign)BOOL m_isSelected;
@property(nonatomic,strong)NSString *m_num;
@property(nonatomic,strong)NSString *m_price;

@property(assign)BOOL m_isCreated;
+(WarehousePurchaseInfo *)from:(NSDictionary *)info;
@end
