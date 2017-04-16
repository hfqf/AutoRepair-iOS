//
//  RepairHistotyTableViewCell.m
//  AutoRepairHelper
//
//  Created by Points on 15/5/2.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "RepairHistotyTableViewCell.h"

@implementation RepairHistotyTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        m_lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5,MAIN_WIDTH/2-10, 20)];
        m_lab1.font = [UIFont systemFontOfSize:14];
        m_lab1.textColor = UIColorFromRGB(0x1A1A1A);
        
        m_labTime = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2, 7,MAIN_WIDTH/2-10, 20)];
        m_labTime.font = [UIFont systemFontOfSize:13];
        [m_labTime setTextAlignment:NSTextAlignmentLeft];
        [m_labTime  setTextColor:UIColorFromRGB(0x878787)];
        
        m_lab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 30,MAIN_WIDTH-20, 20)];
        m_lab2.font = [UIFont systemFontOfSize:13];
        [m_lab2  setTextColor:UIColorFromRGB(0x878787)];

        m_lab3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 55,MAIN_WIDTH-20, 20)];
        m_lab3.font = [UIFont systemFontOfSize:12];
        [m_lab3  setTextColor:UIColorFromRGB(0x707070)];

        m_lab4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80,MAIN_WIDTH-20, 20)];
        [m_lab4 setTextColor:UIColorFromRGB(0x707070)];
        m_lab4.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:m_lab2];
        [self addSubview:m_lab1];
        [self addSubview:m_lab3];
        [self addSubview:m_lab4];
        [self addSubview:m_labTime];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,99.5,MAIN_WIDTH,0.5)];
        line.alpha = 0.3;
        [line setBackgroundColor:KEY_COMMON_CORLOR];
        [self addSubview:line];
    }
    return self;
}

- (void)setInfo:(ADTRepairInfo *)info
{
    ADTContacterInfo *contact = [DB_Shared contactWithCarCode:info.m_carCode];
    _info = info;
    [m_lab1 setText:[NSString stringWithFormat:@"客户 : %@",contact.m_userName]];
    [m_lab2 setText:[NSString stringWithFormat:@"保养项目: %@",info.m_repairType]];
    [m_lab3 setText:[NSString stringWithFormat:@"备注 : %@",info.m_more]];
    [m_labTime setText:[NSString stringWithFormat:@"登记时间 : %@",info.m_insertTime]];
    [m_lab4 setText:[NSString stringWithFormat:@"总收费 : %ld",(long)info.m_totalPrice]];
}

@end
