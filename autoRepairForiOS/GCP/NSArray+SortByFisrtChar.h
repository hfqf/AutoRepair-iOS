//
//  NSArray+SortByFisrtChar.h
//  xxt_xj
//
//  Created by Points on 14-10-14.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#define HANZI_START 19968

/**
 *  按照昵称排序
 */
FOUNDATION_EXPORT NSString * const SORT_FRIEND_NICKNAME_KEY;

#import <Foundation/Foundation.h>
@interface NSArray(sortByFirstChat)

- (NSArray *)sortedFriendArray;
- (NSArray *)sortedFriendArrayByKey:(NSString *)key;


+ (char)pinyinFirstLetter:(u_short)hanzi;
@end
