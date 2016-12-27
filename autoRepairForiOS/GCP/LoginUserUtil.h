//
//  LoginUserUtil.h
//  JZH_Test
//
//  Created by Points on 13-10-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LoginUserUtil : NSObject

//+ (long long)loginUserId;

+ (NSString *)userId;

+ (NSString *)credit;

+ (NSString *)money;



//登录时输入的账户
+ (NSString *)accountOfInput;

+ (NSString *)loginParentId;

+ (NSString *)remoteId;

+ (NSString *)loginIdToIm;


+ (NSString *)IMEI;

+ (NSString *)accountOfCurrentLoginer;

+ (NSString *)nameOfCurrentLoginer;

+ (NSString *)pwdOfCurrentLoginer;



+ (NSString *)accessToken;

//获得联系人后返回的token,再来创建im
+ (NSString *)imToken;

//给后台判断是否需要更新联系人的标识
+ (NSString *)mdSign;

+ (NSDictionary *)readDictionartFromPlist;

+ (NSString *)pathOfCurrentLoginer;

+ (NSString *)extend;

+ (BOOL)isTeacher;

+ (BOOL)writeDictionaryToPlist:(NSDictionary *)protalsDic;


+ (BOOL)isNeedSound;

+ (BOOL)isNeedShake;


#pragma mark - 未读个数
+ (int)numOfNewFriendReq;


#pragma mark -  当前项目

+ (NSString *)userTel;

+ (NSString *)userName;

+ (NSInteger)userVipLevel;

+ (BOOL)isDeviceModifyed;

+ (BOOL)isContactAsynced;
+ (BOOL)isRepairAsynced;
@end
