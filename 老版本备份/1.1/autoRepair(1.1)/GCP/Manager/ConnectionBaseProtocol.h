//
//  ConnectionBaseInterFace.h
//  xxt_xj
//
//  Created by Points on 13-12-4.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#ifndef xxt_xj_ConnectionBaseInterFace_h
#define xxt_xj_ConnectionBaseInterFace_h


@protocol BaseViewControllerDelegate <NSObject>


@optional

//最好放在viewwillappear里
- (void)initView;//显示tabbar

- (void)initData;//隐藏tabbar


@optional

- (void)onShowSliderView;


- (void)backBtnClicked;


//跳到在线资源筛选界面
- (void)onJumpToFilterViewController;


//左右滑动
- (void)dragWithDirect:(UISwipeGestureRecognizerDirection)direction withCurrentTabIndex:(int)tag;

- (void)onLogout;


//侧滑栏几个试图推出一层并显示侧滑栏
- (void)onBackAnaShowSliderView;
@end

#endif

