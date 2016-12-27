//
//  LoginUserUtil.m
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "LoginUserUtil.h"
#import "XXTEncrypt.h"
#import "SqliteDataManager.h"
@implementation LoginUserUtil


+ (NSString *)credit
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"credit"];
    return name;
}

+ (NSString *)money
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"money"];
    return name;
}

//登录时输入的账户
+ (NSString *)accountOfInput
{
    NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGINID_IMTOKEN];
    return  account == nil ? @"" :account;

}
+ (NSString *)nameOfCurrentLoginer
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *name = [dic objectForKey:@"nickName"];
    return name;
}

+ (NSString *)accountOfCurrentLoginer
{
   return  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_ACCOUTN];
}

+ (NSString *)pwdOfCurrentLoginer
{
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_PASSWORD];
    return pwd;
}



+ (NSString *)accessToken
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic objectForKey:@"access_token"];
}

//获得联系人后返回的token,再来创建im
+ (NSString *)imToken
{
    NSString * imToken = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IM_TOKEN];
    imToken = imToken == nil ? @"" : imToken;
    return imToken;
}

//给后台判断是否需要更新联系人的标识
+ (NSString *)mdSign
{
    NSString * sign = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IM_MDSIGN];
    sign = sign == nil ? @"-1" : sign;
    return sign;

}

+ (long long)loginUserId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    long long  userId = [[dic objectForKey:@"id"]longLongValue];
    return  userId;
}


+ (NSString *)userId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return  [dic objectForKey:@"id"] == nil ? @"" : [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
}

+ (NSString *)loginParentId
{
    NSDictionary *dic = [self readDictionartFromPlist];
    return [dic objectForKey:@"id"];
}

+ (NSString *)remoteId
{
    NSString *remote = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_REMOTEID];
    return remote == nil ?@"":remote;
}

+ (NSString *)loginIdToIm
{
    NSDictionary *dic = [self readDictionartFromPlist];
    NSString *loginId = [self isTeacher]?[dic objectForKey:@"id"]:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGINID_IMTOKEN];
    return loginId == nil ? @"" : loginId;
}



+ (BOOL)isTeacher
{
//    NSDictionary *dic = [self readDictionartFromPlist];
//    return [[dic objectForKey:@"role"]intValue] == 0;
    
    return   [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_LOGIN_ROLE]isEqualToString:@"1"];
}

+ (NSString *)extend
{
    NSString * token = [self accessToken];
    NSString *extend = [XXTEncrypt  extendDES:token == nil ? @"":token];
    return extend;
}

+ (NSString *)IMEI
{
   return  @"";//[[[UIDevice currentDevice]identifierForVendor]UUIDString];
}


//家长或老师选择完

#pragma mark - 当前登陆的用户信息

+ (NSString *)pathOfCurrentLoginer
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doc = [paths objectAtIndex:0];
    NSString *path=[doc stringByAppendingPathComponent:@"currentLoginUser.plist"];
    if(![fileManager fileExistsAtPath:path isDirectory:NO])
    {
        NSDictionary * dic = [NSDictionary dictionary];
        [dic writeToFile:path atomically:YES];
    }
    return path;
}


+ (BOOL)writeDictionaryToPlist:(NSDictionary *)protalsDic
{
    if(protalsDic == nil)
    {
        return NO;
    }
    NSString * path = [self pathOfCurrentLoginer];
    NSDictionary * dic = [self checkValueValid:protalsDic];
    return  [dic writeToFile:path atomically:YES];
}

+ (NSDictionary *)readDictionartFromPlist
{
    NSString * path = [self pathOfCurrentLoginer];
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:path];
    return dic;
}

+ (NSDictionary *)checkValueValid :(NSDictionary *)oriDic
{
    int i = 0;
    NSArray * arrValue = [oriDic allValues];
    NSArray *arrKey = [oriDic allKeys];
    NSMutableDictionary * newDic = [[NSMutableDictionary alloc]init];
    for(NSDictionary * dic in oriDic)
    {
        SpeLog(@"%@",dic);
        if([[arrValue objectAtIndex:i] isKindOfClass:[NSNull class]])
        {
            [newDic setObject:@"" forKey:[arrKey objectAtIndex:i]];
        }
        else
        {
            [newDic setObject:[arrValue objectAtIndex:i] forKey:[arrKey objectAtIndex:i]];
        }
        i++;
    }
    return newDic;
}

#pragma mark - 

+ (BOOL)isNeedSound
{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_STATE_SOUND_TIP]isEqualToString:@"1"];
}

+ (BOOL)isNeedShake
{
   return  [[[NSUserDefaults standardUserDefaults]objectForKey:KEY_STATE_SHAKE_TIP]isEqualToString:@"1"];
}


#pragma mark - 未读个数
+ (int)numOfNewFriendReq
{
    NSString *num = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_FRIEND_REQ];
    //return 5;
    return [num intValue];
}


#pragma mark -  当前项目
+ (NSString *)userTel
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUTO_TEL];
    return ret == nil ? @"" : ret;
}

+ (NSString *)userName
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUTO_NAME];
    return ret == nil ? @"" : ret;
}

+ (NSInteger)userVipLevel
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUTO_LEVEL];
    return ret == nil ? 0 : [ret integerValue];
}

+ (BOOL)isDeviceModifyed
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_AUTO_UDID_MODIFYED];
    return ret == nil ? 0 : [ret integerValue] == 1;
}

+ (BOOL)isContactAsynced
{
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IS_CONTACT_AYSNED];
    if(ret == nil)
    {
        return NO;
    }
    else
    {
        if([[SqliteDataManager sharedInstance]quertAllCustoms].count == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return  NO;
}

+ (BOOL)isRepairAsynced
{
    if([[SqliteDataManager sharedInstance]queryAllRepairs].count == 0)
    {
        return NO;
    }
    
    NSString *ret = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IS_REPAIR_AYSNED];
    return ret == nil ? 0 : [ret integerValue] == 1;
}
@end
