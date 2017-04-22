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
        
        m_telLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, MAIN_WIDTH/2-20, 20)];
        [m_telLab setFont:[UIFont systemFontOfSize:14]];
        [m_telLab setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:m_telLab];
        
        
        
        UIView *SEP = [[UIView alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,0,0.5, 60)];
        [SEP setBackgroundColor:KEY_COMMON_CORLOR];
        [self addSubview:SEP];
        
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+10, 10, MAIN_WIDTH/2-20, 20)];
        [m_nameLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_nameLab];
        
        m_carTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2+10, 30, MAIN_WIDTH/2-20, 20)];
        [m_carTypeLab setFont:[UIFont systemFontOfSize:14]];
        [m_carTypeLab setTextAlignment:NSTextAlignmentLeft];
        
  
     
        [self addSubview:m_carTypeLab];
        
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 0.5)];
        topLine.backgroundColor = PUBLIC_BACKGROUND_COLOR;
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0,59.5, MAIN_WIDTH, 0.5)];
        bottomLine.backgroundColor = PUBLIC_BACKGROUND_COLOR;
        [self addSubview:bottomLine];
        
    }
    return self;
}


- (void)setInfoData:(ADTContacterInfo *)infoData
{
    [m_carCodeLab setText:infoData.m_userName];
    [m_nameLab setText:infoData.m_carCode];
    [m_telLab setText:infoData.m_tel];
    [m_carTypeLab setText:infoData.m_carType];
}
@end
