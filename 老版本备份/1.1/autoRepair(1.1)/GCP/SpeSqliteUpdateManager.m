//
//  Created by Points on 15-04-03.
//  Copyright (c) 2015年 Points. All rights reserved.
//

#define KEY_DB_VERSION @"dbVersion"
#define KEY_DB_NAME    @"dbName"
#define KEY_TABLES     @"dbTables"
#define KEY_LOCAL_NAME @"SpeSqlSetting.plist"

#define KEY_SQL_SETTING_PATH  [[NSBundle mainBundle] pathForResource:@"SpeSqlSetting" ofType:@"plist"]

#import "SpeSqliteUpdateManager.h"


@implementation SpeSqliteUpdateManager

SINGLETON_FOR_CLASS(SpeSqliteUpdateManager)


- (void)dealloc
{
    sqlite3_close(m_db);
}

- (id)init

{
    if(self = [super init])
    {
        m_sqlSettingDic = [NSDictionary dictionaryWithContentsOfFile:KEY_SQL_SETTING_PATH];
        NSString *database_path = [self pathLocalDB];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *sqlPath = [documents stringByAppendingPathComponent:KEY_LOCAL_NAME];
        
        m_localSettingDic = [NSDictionary dictionaryWithContentsOfFile:sqlPath];
        SpeLog(@"DB路径=%@",database_path);
        if (sqlite3_open([database_path UTF8String], &m_db) != SQLITE_OK)
        {
            sqlite3_close(m_db);
            SpeLog(@"创建数据库失败");
        }
        else
        {
            [self createTable];
        }
        
        if([self isNeedUpadte])
        {
            [self updateLocalDB];
            [m_sqlSettingDic writeToFile:sqlPath atomically:YES];
        }
    }
    return self;
}

+ (sqlite3 *)db
{
    return  [[SpeSqliteUpdateManager sharedInstance]dbHandle];
}


+(void)createOrUpdateDB
{
    [SpeSqliteUpdateManager sharedInstance];
}

+ (NSString *)dbName
{
    return [[SpeSqliteUpdateManager sharedInstance]DBName];
}

#pragma mark - speSqlSetting.plist


/*
 * 获取新plist的所有表
 *	@brief
 *
 *	@return
 */
- (NSArray *)arrTables

{    
    return m_sqlSettingDic[KEY_TABLES];
}

/**
 *
 *	@brief	数据库名
 *
 *	@return
 */
- (NSString *)DBName

{
    return m_sqlSettingDic[KEY_DB_NAME];
}

/**
 *	@brief	当前数据库版本号
 *
 *	@return
 */
- (NSInteger )currentDBVersion

{
    return [m_sqlSettingDic[KEY_DB_VERSION]integerValue];
}

/**
 *	@brief	是否需要升级(本地无数据库plist和本地版本号小于bundle的plist的版本号)
 *
 *	@return
 */
- (BOOL)isNeedUpadte
{
    NSInteger localDBVersion = [m_localSettingDic[KEY_DB_VERSION]integerValue];
    if(m_localSettingDic == nil)
    {
        return YES;
    }
    return localDBVersion < [self currentDBVersion];
}

#pragma mark - end

/**
 *	@brief	本地数据库plist的路径
 *
 *	@return
 */
- (NSString *)pathLocalDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:[self DBName]];
    return database_path;
}

/**
 *	@brief	升级db
 *
 *	@return
 */
- (void)updateLocalDB
{
    NSArray *arr = [self arrTables];
    if(arr == nil || arr.count == 0)
    {
        return ;
    }
    
    NSArray *arrLocal = m_localSettingDic[KEY_TABLES];
    
    if(arrLocal.count == 0)
    {
        return;
    }
    
    for(NSDictionary *tableDic in arr)//新数据库plist数据
    {
        //新数据库
        /*这边操作基于如下规定:
         //1.plist上的表的字段只增不删
         //2.增加的字段加在最下面
         */
        
        NSString *tableName = nil;
        int searchCount = 0;
        //第一步先判断新plist的表名是不是本地plist已有,没有的话直接新建表
        for(NSDictionary *localSqlDic in arr)
        {
            NSArray *arrKey = tableDic.allKeys;
            if(arrKey.count > 0)
            {
                tableName = [arrKey firstObject];
            }
            
            if(localSqlDic[tableName] == nil)
            {
                searchCount++;
            }
            else
            {
                continue;
            }
        }
        
        if(searchCount == arr.count)//是新表
        {
            [self createTable:tableDic];
        }
        else
        {
            NSArray *newSqlArr = tableDic[tableName];
                for(NSDictionary *localSqlSetDic in arrLocal)
                {
                    if([[localSqlSetDic.allKeys firstObject] isEqualToString:tableName])
                    {
                        NSArray *localSqlArr = localSqlSetDic[tableName];
                        //判断是不是完全一致
                        if([newSqlArr isEqualToArray:localSqlArr])
                        {
                            break;
                        }
                        else
                        {
                            NSArray *addColumn =  [newSqlArr subarrayWithRange:NSMakeRange(localSqlArr.count, newSqlArr.count-localSqlArr.count)];
                            //更新表字段
                            __block  NSMutableString *alterSql = nil;
                            for(NSDictionary *addColumnDic in addColumn)
                            {
                                alterSql = [NSMutableString stringWithFormat:@"alter table %@ add column",tableName];
                                [addColumnDic enumerateKeysAndObjectsUsingBlock:^(id newParaKey, id newParaObj, BOOL * __unused stop) {
                                    
                                    [alterSql appendFormat:@" %@ %@",newParaKey,newParaObj];
                                    
                                }];
                                
                                [self execSql:alterSql];
                                break;
                            }
                            break;
                        }
                    }
            
                }
        }
    }
}

/**
 *	@brief	创建所有表
 *
 *	@return
 */
-(BOOL)createTable
{
    NSArray *arr = [self arrTables];
    if(arr == nil || arr.count == 0)
    {
        return NO;
    }
    
    for(NSDictionary *tableDic in arr)
    {
        [self createTable:tableDic];
    }
    return YES;
}

/**
 *	@brief	创建表的具体逻辑
 *
 *	@return
 */
- (void)createTable:(NSDictionary *)tableDic
{
    __block  NSMutableString *createSql = [NSMutableString stringWithString:@"CREATE TABLE IF NOT EXISTS"];
    
    [tableDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * __unused stop) {
        NSArray *arrColumn = obj;
        if(arrColumn == nil || arrColumn.count == 0)
        {
            return ;
        }
        
        [createSql appendFormat:@"'%@'(",key];
        
        for(NSDictionary *columnDic in arrColumn)
        {
            [columnDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * __unused stop) {
                
                [createSql appendFormat:@"%@ %@,",key,obj];
            }];
        }
        
        createSql = [NSMutableString stringWithString:[createSql substringToIndex:createSql.length-1]];
        [createSql appendFormat:@")"];
    }];
    [self execSql:createSql];

}

-(BOOL)execSql:(NSString *)sql
{
    char *err = NULL;
    if (sqlite3_exec(m_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        SpeLog(@"数据库操作:%@失败!====%s",sql,err);
        return NO;
    }
    else
    {
        SpeLog(@"操作数据成功==sql:%@",sql);
    }
    return YES;
}

- (sqlite3 *)dbHandle
{
    return m_db;
}

@end