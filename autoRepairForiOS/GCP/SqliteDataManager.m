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
    [self deleteAllRepair];
    return YES;
}

- (BOOL)createTable:(NSString *)sql
{
   return [self execSql:sql];
}


#pragma mark - 顾客

- (BOOL)insertNewCustom:(ADTContacterInfo *)info
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'contactsTable' ( 'carCode','name','tel','carType','owner','idFromNode') VALUES ('%@','%@','%@','%@','%@','%@')",info.m_carCode,info.m_userName,info.m_tel,info.m_carType,info.m_owner,info.m_idFromServer];
    return [self execSql:sql];
}

- (BOOL)updateCustom:(NSDictionary *)info
{
    
    return [self execSql: [NSString stringWithFormat:@"update contactsTable set name = '%@' , carCode = '%@',carType = '%@' ,tel= '%@' where  idFromNode = '%@'",info[@"name"],info[@"carCode"],info[@"carType"],info[@"tel" ],info[@"id"]]];
}

- (NSArray *)queryHistoryWithKey:(NSString *)key
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable' where name like '%%%@%%' or tel like '%%%@%%' or carCode like '%%%@%%'",key,key,key];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTContacterInfo *info = [self contactFrom:statement];
            NSArray *arrRepair = [self queryRepairs:info];
            [arr addObjectsFromArray:arrRepair];
        }
    }
    return arr;
}

- (NSArray *)quertAllCustoms
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable' "];
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
    
    return info;
}


- (BOOL)deleteContacts
{
      return  [self execSql: [NSString stringWithFormat:@"delete from contactsTable"]];
}

- (BOOL)deleteCustomAndRepairHisotry:(NSString *)_id with:(NSString *)carCode;
{
    if([self deleteAllRepairWith:carCode])
    {
        return  [self execSql: [NSString stringWithFormat:@"delete from contactsTable where idFromNode = '%@'",_id]];
    }
    return NO;
    
}

- (ADTContacterInfo *)contactWithCarCode:(NSString *)carCode
{
    carCode = [carCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    carCode = [carCode stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    carCode = [carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'contactsTable' where carCode = '%@'",carCode];
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

#pragma mark - end

#pragma mark - 维修记录

- (BOOL)insertRepair:(ADTRepairInfo *)info
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO 'repairHistoryTable' ( 'carCode','totalKm','repairTime','repairType','addition','tipCircle','isCloseTip','circle','isreaded','owner','idFromNode' ,'insertTime') VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",info.m_carCode,info.m_km,info.m_time,info.m_repairType,info.m_more,info.m_targetDate,info.m_isClose?@"1" : @"0",info.m_repairCircle,info.m_isClose?@"1" : @"0",info.m_owner,info.m_idFromNode,info.m_insertTime];
    return [self execSql:sql];
}


- (BOOL)updateOneHistory2Readed:(ADTRepairInfo *)info
{
    return [self execSql: [NSString stringWithFormat:@"update repairHistoryTable set isCloseTip = '1' where ID = '%@'",info.m_Id]];
}

- (BOOL)makeOneHistory:(ADTRepairInfo *)info isClosed:(BOOL)isClosed
{
    return [self execSql: [NSString stringWithFormat:@"update repairHistoryTable set isCloseTip = '%@' where ID = '%@'",isClosed ? @"1" : @"0",info.m_Id]];
}

- (BOOL)updateRepair:(ADTRepairInfo *)info
{
     return [self execSql: [NSString stringWithFormat:@"update repairHistoryTable set totalKm = '%@', repairTime = '%@' ,repairType = '%@', addition = '%@', tipCircle = '%@',circle = '%@' , isreaded = '%@'  where idFromNode = '%@' ",info.m_km,info.m_time,info.m_repairType,info.m_more,info.m_targetDate,info.m_repairCircle,info.m_isClose ? @"1" : @"0",info.m_idFromNode]];
}

- (BOOL)deleteOneRepair:(ADTRepairInfo *)info
{
    return [self execSql: [NSString stringWithFormat:@"delete from repairHistoryTable where ID = '%@'",info.m_Id]];
}

- (BOOL)deleteAllRepairWith:(NSString *)carCode
{
    carCode = [carCode stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    carCode = [carCode stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    carCode = [carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self execSql: [NSString stringWithFormat:@"delete from repairHistoryTable where carCode = '%@'",carCode]];
}


- (BOOL)deleteAllRepair
{
    return [self execSql: [NSString stringWithFormat:@"delete from repairHistoryTable"]];
}


- (NSArray *)queryRepairs:(ADTContacterInfo *)custom
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'repairHistoryTable' where carCode = '%@' order by repairTime desc",custom.m_carCode];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTRepairInfo *info = [self repairFrom:statement];
            [arr addObject:info];
        }
    }
    return arr;
}


- (NSArray *)queryAllRepairs
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'repairHistoryTable' order by repairTime desc"];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTRepairInfo *info = [self repairFrom:statement];
            [arr addObject:info];
        }
    }
    return arr;
}

- (NSArray *)queryTipRepair
{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM 'repairHistoryTable' where date(tipCircle,'localtime') <= date('now','localtime') and isCloseTip = '0' order by  repairTime desc"];
    sqlite3_stmt * statement;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(m_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ADTRepairInfo *info = [self repairFrom:statement];
            [arr addObject:info];
        }
    }
    return arr;
}

- (ADTRepairInfo *)repairFrom:(sqlite3_stmt * )statement
{
    ADTRepairInfo *info = [[ADTRepairInfo alloc]init];
    info.m_Id =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0)  encoding:NSUTF8StringEncoding];
    info.m_carCode =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1)  encoding:NSUTF8StringEncoding];
    info.m_km =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2)  encoding:NSUTF8StringEncoding];
    info.m_time =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3)  encoding:NSUTF8StringEncoding];
    info.m_repairType =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4)  encoding:NSUTF8StringEncoding];
    info.m_more =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5)  encoding:NSUTF8StringEncoding];
    info.m_targetDate =  [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6)  encoding:NSUTF8StringEncoding];
    info.m_isClose =  [[NSString stringWithCString:(char *)sqlite3_column_text(statement, 7)  encoding:NSUTF8StringEncoding]isEqualToString:@"0"];
    info.m_repairCircle = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 8)  encoding:NSUTF8StringEncoding];
    
    
    NSInteger count = sqlite3_column_count(statement);
    if( count > 9)
    {
        char *ret = (char *)sqlite3_column_text(statement, 9);
        if(ret == NULL)
        {
            info.m_isreaded = NO;
        }
        else
        {
            info.m_isreaded = [[NSString stringWithCString:ret  encoding:NSUTF8StringEncoding] integerValue] == 1;
        }
    }
    
    if(count > 10)
    {
        char *ret = (char *)sqlite3_column_text(statement, 10);
        if(ret == NULL)
        {
            //第一次升级后的用户就是之前数据的用户
            info.m_owner = [LoginUserUtil userTel];
        }
        else
        {
            info.m_owner = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 11)
    {
        
        char *ret = (char *)sqlite3_column_text(statement, 11);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_idFromNode = @"";
        }
        else
        {
            info.m_idFromNode = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    if(count > 12)
    {
        
        char *ret = (char *)sqlite3_column_text(statement, 12);
        if(ret == NULL)
        {
            //传空没关系,新版本第一次登录会上传所有本地数据,这个字段用不到
            info.m_insertTime = [LocalTimeUtil getCurrentTime];
        }
        else
        {
            info.m_insertTime = [NSString stringWithCString:ret  encoding:NSUTF8StringEncoding];
        }
    }
    
    return info;
}

@end
