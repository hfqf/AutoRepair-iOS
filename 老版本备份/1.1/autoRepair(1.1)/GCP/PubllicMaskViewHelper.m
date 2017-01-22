//
//  PubllicMaskViewHelper.m
//  JZH_BASE
//
//  Created by Points on 13-11-14.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#define TAG_MASKVIEW  0xAB
#import "PubllicMaskViewHelper.h"

@implementation PubllicMaskViewHelper

//给一个消息提示
+ (void)showTipViewWith:(NSString *)tip inSuperView:(UIView*)superView withDuration:(int)duration
{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.minSize  = CGSizeMake(80, 80);
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = tip;
        hud.margin = 10.f;
        hud.yOffset = 0;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:duration];
}


+ (void)hideView:(UIView *)view  animated:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:view animated:animated];
}

+ (void)showTipViewWith:(NSString *)tip WhenChattingWithCenter:(CGFloat)y withDuration:(int)duration
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.minSize  = CGSizeMake(100, 30);
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = tip;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:duration];
}

+ (void)removeCurrentTipView:(id)tipView
{
    UIView * v = (UIView *)tipView;
    [UIView animateWithDuration:1
                     animations:^{ v.alpha = 0;}
                     completion:^(BOOL isFinished){[v removeFromSuperview];
                     }];
}

+ (void)showWaitingView:(UIView *)parentView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.minSize  = CGSizeMake(80, 80);
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:60];
}

+ (void)removeWaitingView:(UIView *)parentView
{
    [MBProgressHUD hideHUDForView:parentView animated:NO];
}



@end
