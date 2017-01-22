//
//  BaseViewController.h
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013å¹´ Points. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XTNavigationController.h"
#import "ConnectionBaseProtocol.h"

@interface BaseViewController : UIViewController<BaseViewControllerDelegate,UITextFieldDelegate>
{
    UIImageView *navigationBG;
    UIButton *backBtn;
    UILabel *title;
    UIButton *selectBtn;
    NSInteger m_currentInputY;
}
@property(nonatomic,weak) id<BaseViewControllerDelegate>m_delegate;

-(void)handleError:(NSString*)error;

- (void)removeBackBtn;

- (void)setSliderBtn;

- (void)showWaitingView;

- (void)showWaitingViewWith:(int)delay;

- (void)removeWaitingView;

/** 是否来自侧边栏 */
@property (nonatomic, assign) BOOL fromSide;

/** 设置返回按钮图标为home */
- (void)setBackBtnHomeImage;
/** 重置返回按钮图标为返回 */
- (void)resetBackBtnImage;


@end
