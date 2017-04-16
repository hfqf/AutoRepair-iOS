//
//  PubllicMaskViewHelper.h
//  JZH_BASE
//
//  Created by Points on 13-11-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PubllicMaskViewHelper : NSObject

//给一个消息提示
+ (void)showTipViewWith:(NSString *)tip inSuperView:(UIView*)superView withDuration:(NSTimeInterval)duration;

+ (void)hideView:(UIView *)view  animated:(BOOL)animated;

+ (void)showTipViewWith:(NSString *)tip WhenChattingWithCenter:(CGFloat)y withDuration:(int)duration;

+ (void)showWaitingView:(UIView *)parentView;

+ (void)removeWaitingView:(UIView *)parentView;
@end
