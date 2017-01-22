//
//  TopicEmojiUtil.h
//  xxt_xj
//
//  Created by Points on 13-12-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontSizeUtil : NSObject
+ (CGSize)sizeOfString:(NSString *)str withFont:(UIFont *)font;

+ (CGSize)sizeOfString:(NSString *)str withFont:(UIFont *)font withWidth:(int)width;
@end
