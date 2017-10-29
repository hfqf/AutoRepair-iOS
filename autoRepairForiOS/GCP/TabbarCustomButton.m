//
//  TabbarCustomButton.m
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "TabbarCustomButton.h"
#import "EGOImageView.h"

#define WIDTH_IMAGE 25
@implementation TabbarCustomButton

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withUnselectedImg:(NSString *)unSelectedImg withSelectedImg:(NSString *)selecredImg withUnreadType:(ENUM_UNREAD_MESSAGE_TYPE)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setImage:[UIImage imageNamed:unSelectedImg] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selecredImg] forState:UIControlStateSelected];
        [self setImageEdgeInsets:UIEdgeInsetsMake(2, (frame.size.width-WIDTH_IMAGE)/2,frame.size.height-WIDTH_IMAGE-2, (frame.size.width-WIDTH_IMAGE)/2)];
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,WIDTH_IMAGE, self.frame.size.width, HEIGHT_MAIN_BOTTOM-WIDTH_IMAGE)];
        [titleLab setBackgroundColor:[UIColor clearColor]];
        [titleLab setText:title];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:titleLab];
    }
    return self;
}

- (void)setButton:(BOOL)isSelected
{
    self.selected = isSelected;
    [self setBackgroundColor:[UIColor clearColor]];
    [titleLab setTextColor: isSelected ? KEY_COMMON_BLUE_CORLOR :UIColorFromRGB(0x787878)];
}

@end
