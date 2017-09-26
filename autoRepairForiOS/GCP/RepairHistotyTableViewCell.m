//
//  RepairHistotyTableViewCell.m
//  AutoRepairHelper
//
//  Created by Points on 15/5/2.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#define STATE_WIDTH  100
#define HEAD_WIDTH   60
#import "RepairHistotyTableViewCell.h"
#import "EGOImageView+SetImage.h"
@implementation RepairHistotyTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        m_head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, HEAD_WIDTH, HEAD_WIDTH)];
        m_head.layer.cornerRadius = 2;
        m_head.userInteractionEnabled = YES;
        [self addSubview:m_head];
        
        m_nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(m_head.frame)+10,HEAD_WIDTH+20,15)];
        m_nameLab.font = [UIFont systemFontOfSize:12];
        [m_nameLab setTextAlignment:NSTextAlignmentCenter];
        m_nameLab.textColor = UIColorFromRGB(0x444444);
        [self addSubview:m_nameLab];
        
        m_isInShopLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(m_nameLab.frame)+5,HEAD_WIDTH+20,15)];
        m_isInShopLab.font = [UIFont systemFontOfSize:12];
        [m_isInShopLab setTextAlignment:NSTextAlignmentCenter];
        m_isInShopLab.textColor = UIColorFromRGB(0x444444);
        [self addSubview:m_isInShopLab];
        
        m_carInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,10,MAIN_WIDTH-(HEAD_WIDTH+20)-50,20)];
        m_carInfoLab.font = [UIFont systemFontOfSize:15];
        [m_carInfoLab setTextAlignment:NSTextAlignmentLeft];
        m_carInfoLab.textColor = UIColorFromRGB(0X0A0A0A);
        [self addSubview:m_carInfoLab];
        
        m_typelab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_head.frame)+10,CGRectGetMaxY(m_carInfoLab.frame),MAIN_WIDTH-(HEAD_WIDTH)-80,34)];
        m_typelab.font = [UIFont systemFontOfSize:13];
        [m_typelab setBackgroundColor:[UIColor clearColor]];
        m_typelab.numberOfLines = 0;
        m_typelab.lineBreakMode = NSLineBreakByTruncatingTail;
        [m_typelab setTextAlignment:NSTextAlignmentLeft];
        m_typelab.textColor = UIColorFromRGB(0x404040);
        [self addSubview:m_typelab];
        
        
        m_pricelab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-80,35,70, 20)];
        m_pricelab.font = [UIFont systemFontOfSize:11];
        [m_pricelab setTextAlignment:NSTextAlignmentRight];
        m_pricelab.textColor = UIColorFromRGB(0x404040);
        [self addSubview:m_pricelab];

        m_ownlab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-80,55,70, 14)];
        m_ownlab.font = [UIFont systemFontOfSize:11];
        [m_ownlab setTextAlignment:NSTextAlignmentRight];
        m_ownlab.textColor = KEY_COMMON_RED_CORLOR;
        [self addSubview:m_ownlab];
        
        m_sep = [[UIView alloc]initWithFrame:CGRectMake((HEAD_WIDTH+20),CGRectGetMaxY(m_typelab.frame)+5, MAIN_WIDTH-(HEAD_WIDTH+20), 0.5)];
        m_sep.backgroundColor = UIColorFromRGB(0xDBDBDB);
        [self addSubview:m_sep];
        

        m_statelab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-60, 10,50, 25)];
        m_statelab.font = [UIFont systemFontOfSize:14];
        m_statelab.layer.cornerRadius = 2;
        [m_statelab setTextAlignment:NSTextAlignmentCenter];
        m_statelab.textColor =[UIColor whiteColor];
        [self addSubview:m_statelab];
        
        m_enterTimelab = [[UILabel alloc]initWithFrame:CGRectMake((HEAD_WIDTH+20),CGRectGetMaxY(m_sep.frame)+8, MAIN_WIDTH-(HEAD_WIDTH+20)-50, 18)];
        m_enterTimelab.font = [UIFont systemFontOfSize:12];
        [m_enterTimelab setTextAlignment:NSTextAlignmentLeft];
        m_enterTimelab.textColor = UIColorFromRGB(0x404040);
        [self addSubview:m_enterTimelab];
        
        m_wantCompletedTimelab = [[UILabel alloc]initWithFrame:CGRectMake((HEAD_WIDTH+20),CGRectGetMaxY(m_enterTimelab.frame)+3, MAIN_WIDTH-(HEAD_WIDTH+20)-50, 18)];
        m_wantCompletedTimelab.font = [UIFont systemFontOfSize:12];
        [m_wantCompletedTimelab setTextAlignment:NSTextAlignmentLeft];
        m_wantCompletedTimelab.textColor = UIColorFromRGB(0x404040);
        [self addSubview:m_wantCompletedTimelab];
        
        m_indeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-40,CGRectGetMaxY(m_enterTimelab.frame), 30, 20)];
        m_indeLab.font = [UIFont systemFontOfSize:14];
        [m_indeLab setTextAlignment:NSTextAlignmentRight];
        m_indeLab.textColor = KEY_COMMON_BLUE_CORLOR;
        [self addSubview:m_indeLab];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setInfo:(ADTRepairInfo *)info
{
    ADTContacterInfo *contact = [DB_Shared contactWithCarCode:info.m_carCode withContactId:info.m_idFromNode];
    _info = info;
    [m_head setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:contact.m_strHeadUrl]] withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [m_nameLab setText:contact.m_userName];
    [m_isInShopLab setText:[info.m_iswatiinginshop integerValue] == 1 ? @"在店等":@"不在店等"];
    [m_carInfoLab setText:[NSString stringWithFormat:@"%@ %@",contact.m_carCode,contact.m_carType]];
    m_ownlab.hidden = YES;
    if([info.m_state integerValue] == 0){
        [m_statelab setBackgroundColor:KEY_COMMON_LIGHT_BLUE_CORLOR];
        [m_statelab setText:@"维修中"];
    }else if ([info.m_state integerValue] == 1){
        [m_statelab setBackgroundColor:KEY_COMMON_BLUE_CORLOR];
        [m_statelab setText:@"已修完"];
    }else if ([info.m_state integerValue] == 2){
        if(info.m_ownMoney.integerValue == 0){
            [m_statelab setBackgroundColor:KEY_COMMON_GREEN_CORLOR];
            [m_statelab setText:@"已提车"];
        }else{
            m_ownlab.hidden = NO;
            [m_statelab setBackgroundColor:KEY_COMMON_RED_CORLOR];
            [m_statelab setText:@"挂帐中"];
            [m_ownlab setText:[NSString stringWithFormat:@"欠¥ %@",info.m_ownMoney]];
        }

    }else if ([info.m_state integerValue] == 3){
        [m_statelab setBackgroundColor:KEY_COMMON_GRAY_CORLOR];
        [m_statelab setText:@"已取消"];
    }
    
    [m_typelab setText:[NSString stringWithFormat:@"服务项目:%@",info.m_repairType]];
    
    [m_pricelab setText:[NSString stringWithFormat:@"总¥ %ld",(long)info.m_totalPrice]];
    
    [m_enterTimelab setText:[NSString stringWithFormat:@"进入门店时间:  %@",info.m_entershoptime]];
    [m_wantCompletedTimelab setText:[NSString stringWithFormat:@"%@:  %@",[info.m_state isEqualToString:@"2"] ? @"实际提车时间":@"预计提车时间",info.m_wantedcompletedtime]];
    [m_indeLab setText:info.m_index];
}

@end
