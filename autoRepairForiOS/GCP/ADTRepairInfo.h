//
//  ADTRepairInfo.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTContacterInfo.h"

@interface ADTRepairInfo : NSObject
@property (nonatomic,strong)NSString *m_carCode;
@property (nonatomic,strong)NSString *m_km;
@property (nonatomic,strong)NSString *m_time;
@property (nonatomic,strong)NSString *m_targetDate;
@property (nonatomic,strong)NSString *m_repairType;
@property (nonatomic,strong)NSString *m_more;
@property (nonatomic,strong)NSString *m_repairCircle;
@property (nonatomic,assign)BOOL   m_isClose;
@property (nonatomic,assign)BOOL   m_isreaded;
@property (nonatomic,strong)NSString *m_owner;
@property (nonatomic,strong)NSString *m_idFromNode;
@property (nonatomic,strong)NSString *m_insertTime;
@property (nonatomic,assign)NSInteger m_totalPrice;
@property (nonatomic,assign)BOOL   m_isAddNewRepair;
@property (nonatomic,strong)NSMutableArray  *m_arrRepairItem;///维续内容，个数，价格

@property (nonatomic,strong)NSString*   m_entershoptime;
@property (nonatomic,strong)NSString *m_state;
@property (nonatomic,strong)NSString *m_wantedcompletedtime;
@property (nonatomic,strong)NSString *m_customremark;
@property (nonatomic,strong)NSString *m_iswatiinginshop;
@property (nonatomic,strong)NSString *m_contactid;
@property (nonatomic,strong)NSString *m_index;
+ (ADTRepairInfo *)from:(NSDictionary *)info;

+ (ADTRepairInfo *)initWith:(ADTContacterInfo *)contact;

- (void)updateTotalPrice;
@end
