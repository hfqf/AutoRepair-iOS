//
//  TabbarCustomButton.h
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TabbarCustomButton : UIButton
{
    UILabel * titleLab;
}
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withUnselectedImg:(NSString *)unSelectedImg withSelectedImg:(NSString *)selecredImg withUnreadType:(ENUM_UNREAD_MESSAGE_TYPE)type;

- (void)setButton:(BOOL)isSelected;
@end
