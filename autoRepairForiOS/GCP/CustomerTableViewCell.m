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
        [m_carCodeLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_carCodeLab];
        
        UIView *SEP = [[UIView alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,0,0.5, 40)];
        [SEP setBackgroundColor:KEY_COMMON_CORLOR];
        [self addSubview:SEP];
        
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+10, 10, MAIN_WIDTH/2-20, 20)];
        [m_nameLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_nameLab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,39.5,MAIN_WIDTH,0.5)];
        line.alpha = 0.3;
        [line setBackgroundColor:KEY_COMMON_CORLOR];
        [self addSubview:line];
    }
    return self;
}


- (void)setInfoData:(ADTContacterInfo *)infoData
{
    [m_carCodeLab setText:infoData.m_userName];
    [m_nameLab setText:infoData.m_carCode];
}
@end
