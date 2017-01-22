//
//  TabbarCustomButton.m
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "TabbarCustomButton.h"
#import "EGOImageView.h"

@implementation TabbarCustomButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withUnselectedImg:(NSString *)unSelectedImg withSelectedImg:(NSString *)selecredImg withUnreadType:(ENUM_UNREAD_MESSAGE_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, HEIGHT_MAIN_BOTTOM)];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:title];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont boldSystemFontOfSize:20]];
        [self addSubview:titleLab];
    }
    return self;
}

- (void)setButton:(BOOL)isSelected
{
    [self setBackgroundColor:[UIColor clearColor]];
    [titleLab setTextColor: isSelected ? KEY_COMMON_CORLOR :UIColorFromRGB(0x787878)];
}

@end
