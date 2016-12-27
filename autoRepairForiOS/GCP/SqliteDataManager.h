//
//  SqliteDataManager.h
//  JZH_Test
//  数据库管理类
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface SqliteDataManager : NSObject
{
    sqlite3   *m_db;
}

SINGLETON_FOR_HEADER(SqliteDataManager)

- (BOOL)createTable:(NSString *)tableName;

#pragma mark - 顾客

- (BOOL)insertNewCustom:(ADTContacterInfo *)info;

- (BOOL)updateCustom:(NSDictionary *)info;

- (NSArray *)queryHistoryWithKey:(NSString *)key;

- (BOOL)deleteCustomAndRepairHisotry:(NSString *)carCode;

- (ADTContacterInfo *)contactWithCarCode:(NSString *)carCode;

- (NSArray *)quertAllCustoms;

- (BOOL)deleteContacts;
#pragma mark - end

#pragma mark - 维修记录

- (BOOL)insertRepair:(ADTRepairInfo *)info;

- (BOOL)makeOneHistory:(ADTRepairInfo *)info isClosed:(BOOL)isClosed;

- (BOOL)updateOneHistory2Readed:(ADTRepairInfo *)info;

- (BOOL)deleteOneRepair:(ADTRepairInfo *)info;

- (BOOL)deleteAllRepairWith:(NSString *)carCode;

- (NSArray *)queryRepairs:(ADTContacterInfo *)custom;

- (NSArray *)queryAllRepairs;

- (NSArray *)queryTipRepair;
@end
