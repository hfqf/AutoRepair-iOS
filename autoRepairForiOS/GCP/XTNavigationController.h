//
//  XTNavigationController.h
//  JZH_Test
//
//  Created by Points on 13-10-11.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTNavigationController : UINavigationController
{
    UIImageView *m_navigationBar;
}

//旋转方向 默认竖屏
@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;


@end
