//
//  SqliteDataManager.h
//  JZH_Test
//  数据库管理类
//  Created by Points on 13-10-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "ADTRepairItemInfo.h"
@interface SqliteDataManager : NSObject
{
    sqlite3   *m_db;
}

SINGLETON_FOR_HEADER(SqliteDataManager)

///因为版本升级原因,需要同步服务器的数据，本地的数据库记录需要删除掉
- (BOOL)clearAllLocalDBHistory;

- (BOOL)createTable:(NSString *)tableName;

#pragma mark - 顾客

- (BOOL)insertNewCustom:(ADTContacterInfo *)info;

///同时还要修改所有 所有维修记录里的carcode
- (BOOL)updateCustom:(NSDictionary *)info;

- (BOOL)updateCustomer:(ADTContacterInfo *)info;

- (BOOL)updateCustomHeadUrl:(NSString *)url;

- (NSArray *)queryHistoryWithKey:(NSString *)key;

- (BOOL)deleteCustomAndRepairHisotry:(NSString *)_id with:(NSString *)carCode;

- (ADTContacterInfo *)contactWithCarCode:(NSString  *)carcode withContactId:(NSString *)contactId;

- (ADTContacterInfo *)contactWithOpenId:(NSString  *)openId;

- (NSArray *)quertAllCustoms:(NSString *)key;

- (BOOL)deleteContacts;
#pragma mark - end

@end
