//
//  CustomerTableViewCell.m
//  AutoRepairHelper
//
//  Created by Points on 15/5/1.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "CustomerTableViewCell.h"

@implementation CustomerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        m_carCodeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MAIN_WIDTH/2-20, 20)];
        [self addSubview:m_carCodeLab];
        
        UIView *SEP = [[UIView alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 1, 1, 38)];
        SEP.alpha = 0.2;
        [SEP setBackgroundColor:[UIColor grayColor]];
        [self addSubview:SEP];
        
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+10, 10, MAIN_WIDTH/2-20, 20)];
        [self addSubview:m_nameLab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,39.5,MAIN_WIDTH,0.5)];
        line.alpha = 0.3;
        [line setBackgroundColor:[UIColor grayColor]];
        [self addSubview:line];
    }
    return self;
}


- (void)setInfoData:(ADTContacterInfo *)infoData
{
    [m_carCodeLab setText:infoData.m_carCode];
    [m_nameLab setText:infoData.m_userName];
}
@end
