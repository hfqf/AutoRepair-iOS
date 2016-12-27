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
        float yOrigin = 60;
        float leftSpace = 100; //第一个图片距离左边的距离
        float rightSpace = 100;//最后一个图片距离右边的距离
        float imageWidth = 30; //每个图片的尺寸大小
        float betweenSpace = (MAIN_WIDTH-leftSpace-rightSpace-imageWidth*3)/2; //计算每张图片之间的距离
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, yOrigin, imageWidth, imageWidth)];
        imgView1.image = [UIImage imageNamed:@"tabbar_bottom1_un"];
        [self addSubview:imgView1];
        
        UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView1.frame)+betweenSpace, yOrigin, imageWidth, imageWidth)];
        imgView2.image = [UIImage imageNamed:@"tabbar_bottom3_un"];
        [self addSubview:imgView2];
        
        UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView2.frame)+betweenSpace, yOrigin, imageWidth, imageWidth)];
        imgView3.image = [UIImage imageNamed:@"tabbar_bottom4_un"];
        [self addSubview:imgView3];

        
        
        UILabel *tipLab  = [[UILabel alloc]initWithFrame:CGRectMake(0,100,MAIN_WIDTH, 30)];
        [tipLab setBackgroundColor:[UIColor clearColor]];
        [tipLab setText:@"你可以搜索到新闻,学习,答疑相关内容"];
        [tipLab setFont:[UIFont systemFontOfSize:16]];
        [tipLab setTextAlignment:NSTextAlignmentCenter];
        [tipLab setTextColor:UIColorFromRGB(0xBABABA)];
        [self addSubview:tipLab];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        float btnWidth = 150;
        searchBtn.frame = CGRectMake((MAIN_WIDTH-btnWidth)/2, CGRectGetMaxY(tipLab.frame)+10, btnWidth, 40);
        searchBtn.layer.cornerRadius = 5;
        [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        searchBtn.backgroundColor = UIColorFromRGB(0x0099FD);
        [self addSubview:searchBtn];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithTip:(NSString *)tip
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
        
        UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-40, (frame.size.height-38)/2, 37, 38)];
        imgView1.image = [UIImage imageNamed:@"noDatadefault@3x"];
        [self addSubview:imgView1];
        
        UILabel *tipLab  = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2+10,(frame.size.height-30)/2,MAIN_WIDTH, 30)];
        [tipLab setBackgroundColor:[UIColor clearColor]];
        [tipLab setText:tip];
        [tipLab setFont:[UIFont systemFontOfSize:16]];
        [tipLab setTextAlignment:NSTextAlignmentLeft];
        [tipLab setTextColor:UIColorFromRGB(0xBABABA)];
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
