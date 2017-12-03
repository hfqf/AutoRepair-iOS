//
//  ADTEmployeeInfo.h
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/12/1.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTEmployeeInfo : NSObject
@property(assign)BOOL m_isAddNew;
@property(nonatomic,strong)NSString *m_id;
@property(nonatomic,strong)NSString *m_userName;
@property(nonatomic,strong)NSString *m_pwd;
@property(nonatomic,strong)NSString *m_headUrl;
@property(nonatomic,strong)NSString *m_sex;
@property(nonatomic,strong)NSString *m_age;
@property(nonatomic,strong)NSString *m_desc;
@property(nonatomic,strong)NSString *m_tel;
@property(nonatomic,strong)NSString *m_roleType;
@property(nonatomic,strong)NSString *m_registerTime;

+ (ADTEmployeeInfo *)from:(NSDictionary *)info;

@end
