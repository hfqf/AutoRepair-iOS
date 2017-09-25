//
//  ADTRepairItemInfo.h
//  AutoRepairHelper3
//
//  Created by points on 2017/4/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WareHouseGoods.h"
@interface ADTRepairItemInfo : NSObject

@property (nonatomic,strong)NSString *m_repid;
@property (nonatomic,strong)NSString *m_contactid;
@property (nonatomic,strong)NSString *m_price;
@property (nonatomic,strong)NSString *m_num;
@property (nonatomic,strong)NSString *m_type;
@property (nonatomic,strong)NSString *m_id;
@property (nonatomic,strong)NSString *m_itemType;
@property (nonatomic,strong)NSString *m_goodsId;
@property (nonatomic,strong)NSString *m_serviceId;
@property (assign) NSInteger  m_currentPrice;
+ (ADTRepairItemInfo *)from:(NSDictionary *)info;

@end
