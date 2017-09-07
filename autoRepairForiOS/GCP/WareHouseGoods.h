//
//  WareHouseGoods.h
//  AutoRepairHelper3
//
//  Created by points on 2017/8/28.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WareHouseGoods : NSObject
@property(nonatomic,strong) NSString *m_picurl;
@property(nonatomic,strong) NSString *m_name;
@property(nonatomic,strong) NSString *m_goodsencode;
@property(nonatomic,strong) NSDictionary *m_category;
@property(nonatomic,strong) NSDictionary *m_subtype;
@property(nonatomic,strong) NSString *m_saleprice;
@property(nonatomic,strong) NSString *m_costprice;
@property(nonatomic,strong) NSString *m_productertype;
@property(nonatomic,strong) NSString *m_producteraddress;
@property(nonatomic,strong) NSString *m_barcode;
@property(nonatomic,strong) NSString *m_brand;
@property(nonatomic,strong) NSString *m_unit;
@property(nonatomic,strong) NSString *m_minnum;
@property(nonatomic,strong) NSString *m_applycartype;
@property(nonatomic,strong) NSString *m_remark;
@property(nonatomic,strong) NSString *m_isactive;
@property(nonatomic,strong) NSString *m_owner;
@property(nonatomic,strong) NSString *m_id;
+(WareHouseGoods *)from:(NSDictionary *)info;
@end
