//
//  ADTRepairInfo.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTRepairInfo : NSObject
@property (nonatomic,strong)NSString *m_Id;
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

@end
