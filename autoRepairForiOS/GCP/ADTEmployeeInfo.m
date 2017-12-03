//
//  ADTEmployeeInfo.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/12/1.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ADTEmployeeInfo.h"

@implementation ADTEmployeeInfo

+ (ADTEmployeeInfo *)from:(NSDictionary *)info 
{
    ADTEmployeeInfo *ret = [[ADTEmployeeInfo alloc]init];
    ret.m_isAddNew = NO;
    ret.m_id = [info stringWithFilted:@"_id"];
    ret.m_age = [info stringWithFilted:@"age"];
    ret.m_sex = [info stringWithFilted:@"sex"];
    ret.m_tel = [info stringWithFilted:@"tel"];
    ret.m_userName = [info stringWithFilted:@"username"];
    ret.m_registerTime= [info stringWithFilted:@"registertime"];
    ret.m_roleType = [info stringWithFilted:@"roletype"];
    ret.m_headUrl = [info stringWithFilted:@"headurl"];
    ret.m_pwd = [info stringWithFilted:@"pwd"];
    ret.m_desc = [info stringWithFilted:@"desc"];
    return ret;
}
@end
