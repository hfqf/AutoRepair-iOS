//
//  WarehousePurchaseInfo.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/8.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarehousePurchaseInfo : NSObject
@property(nonatomic,strong)NSString *m_state;
@property(nonatomic,strong)NSDictionary *m_storePosition;
@property(nonatomic,strong)NSString *m_payType;
@property(nonatomic,strong)NSString *m_expressPayType;
@property(nonatomic,strong)NSString *m_expressCompany;
@property(nonatomic,strong)NSString *m_expressSerialId;
@property(nonatomic,strong)NSString *m_expressCost;
@property(nonatomic,strong)NSDictionary *m_supplier;
@property(nonatomic,strong)NSString *m_remark;
@property(nonatomic,strong)NSArray  *m_arrGoods;
@property(nonatomic,strong)NSString *m_id;
@end
