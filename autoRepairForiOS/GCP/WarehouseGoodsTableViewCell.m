//
//  WarehouseGoodsTableViewCell.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsTableViewCell.h"

@implementation WarehouseGoodsTableViewCell

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
        [m_nameLab setTextColor:[UIColor blackColor]];
        [self addSubview:m_nameLab];

        m_priceLab = [[UILabel alloc]initWithFrame:CGRectMake(65,40, 120, 20)];
        [m_priceLab setFont:[UIFont systemFontOfSize:15]];
        [m_priceLab setTextAlignment:NSTextAlignmentLeft];
        [m_priceLab setTextColor:KEY_COMMON_BLUE_CORLOR];
        [self addSubview:m_priceLab];

        m_selectIcon = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-40, 15, 30, 30)];
        [self addSubview:m_selectIcon];

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        [self addSubview:sep];

    }
    return self;
}


- (void)setInfoData:(WareHouseGoods *)infoData
{

    

    [m_head setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:infoData.m_picurl] ]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [m_nameLab setText:infoData.m_name];
    [m_priceLab setText:infoData.m_saleprice];

    m_selectIcon.hidden = !infoData.m_isSelectStyle;
    m_selectIcon.image = [UIImage imageNamed:infoData.m_isSelected ? @"check_on":@"check_un"];
}
@end
