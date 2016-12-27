//
//  Created by Points on 15-04-03.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define SINGLETON_FOR_HEADER(className) \
+ (className *)sharedInstance;

//单例实现的公用函数
#define SINGLETON_FOR_CLASS(className) \
+ (className *)sharedInstance { \
static className *shared = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared = [[self alloc] init]; \
}); \
return shared; \
}

@interface SpeSqliteUpdateManager : NSObject
{
    sqlite3         *m_db;
    NSDictionary    *m_sqlSettingDic;//在bundle中的数据库plist，即新plist
    NSDictionary    *m_localSettingDic;//本地的数据库plist
}

SINGLETON_FOR_HEADER(SpeSqliteUpdateManager)

//创建或升级本地数据库
+(void)createOrUpdateDB;

//db名
+ (NSString *)dbName;

+ (sqlite3 *)db;

- (NSString *)pathLocalDB;

@end
