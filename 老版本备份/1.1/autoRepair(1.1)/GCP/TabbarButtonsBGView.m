//
//  TabbarButtonsBGView.m
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "TabbarButtonsBGView.h"

@implementation TabbarButtonsBGView
- (void)dealloc
{
    self.m_delegate = nil;
    self.m_arrBGButton = nil;
}

- (id)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)arrTitle
withUnSelectedImgArray:(NSArray *)arrUnSelected
    withSelectedArr:(NSArray *)arrSelected
withButtonNum:(int)num
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        [self setBackgroundColor:UIColorFromRGB(0xF6F6F6)];
        NSMutableArray * arr = [NSMutableArray array];
        for(int i=0;i<num;i++)
        {
            ENUM_UNREAD_MESSAGE_TYPE type = ENUM_UNREAD_NONE;
            TabbarCustomButton * btn = [[TabbarCustomButton alloc]initWithFrame:CGRectMake((MAIN_WIDTH/num)*i, 0, (MAIN_WIDTH/num), HEIGHT_MAIN_BOTTOM) withTitle:[arrTitle objectAtIndex:i] withUnselectedImg:[arrUnSelected objectAtIndex:i] withSelectedImg:[arrSelected objectAtIndex:i] withUnreadType:type];
            btn.tag = i;
            [btn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [arr addObject:btn];
        }
        self.m_arrBGButton = arr;
    }
    return self;
}

- (void)selected:(TabbarCustomButton *)sender
{
    if(self.m_delegate &&[self.m_delegate respondsToSelector:@selector(onSelectedWithButtonIndex:)])
    {
        [self.m_delegate onSelectedWithButtonIndex:(int)sender.tag];
    }
}



- (void)refreshWithCurrentSelected:(int)index
{
    for(int i=0;i<self.m_arrBGButton.count;i++)
    {
        TabbarCustomButton *btn = [self.m_arrBGButton objectAtIndex:i];
        [btn setButton:(index==i)];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
