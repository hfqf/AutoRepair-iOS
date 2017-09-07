//
//  SqliteDataManager.m
//  JZH_Test
//
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "SqliteDataManager.h"
#import "SpeSqliteUpdateManager.h"
@implementation SqliteDataManager

- (id)init

{
    if(self = [super init])
    {
        
        [SpeSqliteUpdateManager createOrUpdateDB];
         m_db = [SpeSqliteUpdateManager db];
        
        
    }
    return self;
}

SINGLETON_FOR_CLASS(SqliteDataManager)

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

#pragma mark -  数据库操作

///因为版本升级原因,需要同步服务器的数据，本地的数据库记录需要删除掉
- (BOOL)clearAllLocalDBHistory
{
    [self deleteContacts];
    return YES;
}

- (BOOL)createTable:(NSString *)sql
{
   return [self execSql:sql];
}


#pragma mark - 顾客

- (BOOL)insertNewCustom:(ADTContacterInfo *)info
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'contactsTable' ( 'carCode','name','tel','carType','owner','idFromNode','inserttime','isbindweixin','weixinopenid','vin','carregistertime','headurl') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",info.m_carCode,info.m_userName,info.m_tel,info.m_carType,info.m_owner,info.m_idFromServer,info.m_strInsertTime,info.m_strIsBindWeixin,info.m_strWeixinOPneid,info.m_strVin,info.m_strCarRegistertTime,info.m_strHeadUrl];
    return [self execSql:sql];
}

- (BOOL)updateCustom:(NSDictionary *)info
{
    
    return [self execSql: [NSString stringWithFormat:@"update contactsTable set name = '%@' , carCode = '%@',carType = '%@' ,tel= '%@' ,inserttime='%@' ,isbindweixin='%@',weixinopenid='%@',vin='%@',carregistertime='%@',headurl='%@'  where  idFromNode = '%@'",info[@"name"],info[@"carCode"],info[@"carType"],info[@"tel" ],info[@"id"],info[@"inserttime"],info[@"isbindweixin"],info[@"weixinopenid"],info[@"vin"],info[@"carregistertime"],info[@"headurl"]]];
}


- (BOOL)updateCustomer:(ADTContacterInfo *)info
{
    return [self execSql: [NSString stringWithFormat:@"update contactsTable set name = '%@' , carCode = '%@',carType = '%@' ,tel= '%@' ,inserttime='%@' ,isbindweixin='%@',weixinopenid='%@',vin='%@',carregistertime='%@',headurl='%@'  where  idFromNode = '%@'",info.m_userName,info.m_carCode,info.m_carType,info.m_tel,info.m_strInsertTime,info.m_strIsBindWeixin,info.m_strWeixinOPneid,info.m_strVin,info.m_strCarRegistertTime,info.m_strHeadUrl,info.m_idFromServer]];
}

- (BOOL)updateCustomHeadUrl:(ADTContacterInfo *)contact
{
    return [self execSql: [NSString stringWithFormat:@"update contactsTable set headurl='%@'  where  idFromNode = '%@'",contact.m_strHeadUrl,contact.m_idFromServer]];
}

- (NSArray *)queryHistoryWithKey:(NSString *)key
{
    return nil;
//    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable' where name like '%%%@%%' or tel like '%%%@%%' or carCode like '%%%@%%'",key,key,key];
//    sqlite3_stmt * statement;
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
//    {
//        while (sqlite3_step(statement) == SQLITE_ROW)
//        {
//            ADTContacterInfo *info = [self contactFrom:statement];
//            NSArray *arrRepair = [self queryRepairs:info];
//            [arr addObjectsFromArray:arrRepair];
//        }
//    }
//    return arr;
}

- (NSArray *)quertAllCustoms:(NSString *)key
{
    NSString *sqlQuery = nil;
    if(key.length == 0)
    {
        sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable'"];
    }
    else
    {
        sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable'  where name like '%%%@%%' or tel like '%%%@%%' or carCode like '%%%@%%'",key,key,key];
    }
    
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTContacterInfo *info = [self contactFrom:statement];
            [arr addObject:info];
        }
    }
   return arr;
}

- (ADTContacterInfo *)contactFrom:(sqlite3_stmt * )statement
{
    ADTContacterInfo *info = [[ADTContacterInfo alloc]init];
    info.m_carCode =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0)  encoding:NSUTF8StringEncoding];
    info.m_userName =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1)  encoding:NSUTF8StringEncoding];
    info.m_tel =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2)  encoding:NSUTF8StringEncoding];
    info.m_carType =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3)  encoding:NSUTF8StringEncoding];
    
    
    NSInteger count = sqlite3_column_count(statement);
    if(count > 4)
    {
        const unsigned char *ower = sqlite3_column_text(statement, 4);
        if(ower == NULL)
        {
            //第一次升级后的用户就是之前数据的用户
            info.m_owner = [LoginUserUtil userTel];
        }
        else
        {
            info.m_owner =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4)  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 5)
    {
        
        char *ret = (char *)sqlite3_column_text(statement, 5);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_idFromServer = @"";
        }
        else
        {
            info.m_idFromServer = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 6){
        char *ret = (char *)sqlite3_column_text(statement, 6);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_strInsertTime = @"";
        }
        else
        {
            info.m_strInsertTime = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 7){
        char *ret = (char *)sqlite3_column_text(statement, 7);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_strIsBindWeixin = @"0";
        }
        else
        {
            info.m_strIsBindWeixin = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    
    if(count > 8){
        char *ret = (char *)sqlite3_column_text(statement, 8);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_strWeixinOPneid = @"0";
        }
        else
        {
            info.m_strWeixinOPneid = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 9){
        char *ret = (char *)sqlite3_column_text(statement, 9);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_strVin = @"0";
        }
        else
        {
            info.m_strVin = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 10){
        char *ret = (char *)sqlite3_column_text(statement, 10);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_strCarRegistertTime = @"0";
        }
        else
        {
            info.m_strCarRegistertTime = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 11){
        char *ret = (char *)sqlite3_column_text(statement, 11);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_strHeadUrl = @"0";
        }
        else
        {
            info.m_strHeadUrl = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    return info;
}


- (BOOL)deleteContacts
{
      return  [self execSql: [NSString stringWithFormat:@"delete from contactsTable"]];
}

- (BOOL)deleteCustomAndRepairHisotry:(NSString *)_id with:(NSString *)carCode;
{
     return  [self execSql: [NSString stringWithFormat:@"delete from contactsTable where idFromNode = '%@'",_id]];
}

- (ADTContacterInfo *)contactWithCarCode:(NSString  *)carcode withContactId:(NSString *)contactId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable' where idFromNode = '%@' or carCode = '%@'",contactId,carcode];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTContacterInfo *info = [self contactFrom:statement];
            return info;
        }
    }
    return nil;
}

- (ADTContacterInfo *)contactWithOpenId:(NSString  *)openId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable' where weixinopenid = '%@'",openId];
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTContacterInfo *info = [self contactFrom:statement];
            return info;
        }
    }
    return nil;
}


@end
