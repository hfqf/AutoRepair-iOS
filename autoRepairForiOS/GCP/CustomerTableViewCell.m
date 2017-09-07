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

        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self addSubview:m_head];
        
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(65,5, MAIN_WIDTH/2, 20)];
        [m_nameLab setFont:[UIFont systemFontOfSize:15]];
        [m_nameLab setTextAlignment:NSTextAlignmentLeft];
        [m_nameLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [self addSubview:m_nameLab];
        
        m_telLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-140, 5, 120, 20)];
        [m_telLab setFont:[UIFont systemFontOfSize:12]];
        [m_telLab setTextAlignment:NSTextAlignmentRight];
        [m_telLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [self addSubview:m_telLab];
        
        
        m_carCodeLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 38, MAIN_WIDTH-60-100, 20)];
        [m_carCodeLab setFont:[UIFont systemFontOfSize:14]];
        [m_carCodeLab setTextAlignment:NSTextAlignmentLeft];
        [m_carCodeLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [self addSubview:m_carCodeLab];
        
        
        m_carTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120, 38,100, 20)];
        [m_carTypeLab setFont:[UIFont systemFontOfSize:14]];
        [m_carTypeLab setTextAlignment:NSTextAlignmentRight];
        [m_carTypeLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [self addSubview:m_carTypeLab];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        [self addSubview:sep];
        
    }
    return self;
}


- (void)setInfoData:(ADTContacterInfo *)infoData
{
    [m_head setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:infoData.m_strHeadUrl] ]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [m_nameLab setText:infoData.m_userName];
    [m_telLab setText:infoData.m_tel];
    [m_carCodeLab setText:[NSString stringWithFormat:@"%@ %@",infoData.m_carCode,infoData.m_carType]];

    [m_carTypeLab setText:infoData.m_strIsBindWeixin.integerValue == 1 ? @"已绑定微信" : @"未绑定微信"];
}
@end
