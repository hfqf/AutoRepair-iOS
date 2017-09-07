//
//  EmptyTipView.m
//  JZH_BASE
//
//  Created by Points on 13-11-18.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "EmptyTipView.h"

@implementation EmptyTipView

- (id)copyWithZone:(NSZone *)zone;
{
    EmptyTipView *copy = [[[self class] allocWithZone: zone]
                            init];
    return copy;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:UIColorFromRGB(0xEBEBEB)];

        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithTip:(NSString *)tip
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *tipLab  = [[UILabel alloc]initWithFrame:CGRectMake(0,(frame.size.height-30)/2,MAIN_WIDTH, 30)];
        [tipLab setBackgroundColor:[UIColor clearColor]];
        [tipLab setText:tip];
        [tipLab setFont:[UIFont systemFontOfSize:20]];
        [tipLab setTextAlignment:NSTextAlignmentCenter];
        [tipLab setTextColor:[UIColor blackColor]];
        [self addSubview:tipLab];
    }
    return self;
}

- (id)initWithOrderFrame:(CGRect)frame WithTip:(NSString *)tip
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-37)/2, (frame.size.height-38)/2-20, 37, 38)];
        imgView1.image = [UIImage imageNamed:@"noDatadefault@3x"];
        [self addSubview:imgView1];
        
        UILabel *tipLab  = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imgView1.frame)+10,MAIN_WIDTH, 30)];
        [tipLab setBackgroundColor:[UIColor clearColor]];
        [tipLab setText:tip];
        [tipLab setFont:[UIFont systemFontOfSize:16]];
        [tipLab setTextAlignment:NSTextAlignmentCenter];
        [tipLab setTextColor:UIColorFromRGB(0xBABABA)];
        [self addSubview:tipLab];
    }
    return self;
}

- (void)searchBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBtnClicked:)]) {
        [self.delegate performSelector:@selector(searchBtnClicked:) withObject:nil];
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
