//
//  ADTContacterInfo.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTContacterInfo : NSObject
@property (nonatomic,strong)NSString *m_carCode;
@property (nonatomic,strong)NSString *m_userName;
@property (nonatomic,strong)NSString *m_tel;
@property (nonatomic,strong)NSString *m_carType;
@property (nonatomic,strong)NSString *m_owner;
@property (nonatomic,strong)NSString *m_idFromServer;
@property (nonatomic,strong) NSString *m_strInsertTime;
@property (nonatomic,strong) NSString *m_strIsBindWeixin;
@property (nonatomic,strong) NSString *m_strWeixinOPneid;
@property (nonatomic,strong) NSString *m_strVin;
@property (nonatomic,strong) NSString *m_strCarRegistertTime;
@property (nonatomic,strong) NSString *m_strHeadUrl;
@property (nonatomic,strong) NSString *m_strFirstChar;

@property (assign)BOOL m_isSearch;
@property (assign)BOOL m_isAddNew;

@end
