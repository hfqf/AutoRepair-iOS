//
//  ServiceManagerTableViewCell.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/24.
//  Copyright © 2017年 Poitns. All rights reserved.
//
#define HIGH_CELL  40

#import "ServiceManagerTableViewCell.h"

@implementation ServiceManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;

        tip1 = [[UILabel alloc]initWithFrame:CGRectMake(40,10,MAIN_WIDTH-50,20)];
        [tip1 setBackgroundColor:[UIColor clearColor]];
        [tip1 setTextAlignment:NSTextAlignmentLeft];
        [tip1 setFont:[UIFont systemFontOfSize:14]];
        [tip1 setTextColor:[UIColor blackColor]];
        [self addSubview:tip1];


        reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reduceBtn addTarget:self action:@selector(reduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [reduceBtn setFrame:CGRectMake(MAIN_WIDTH-120,5, 40, 30)];
        [reduceBtn setImage:[UIImage imageNamed:@"goods_reduce"] forState:UIControlStateNormal];
        [self addSubview:reduceBtn];

        serviceNeedNumLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reduceBtn.frame), 5, 40, 20)];
        [serviceNeedNumLab setTextAlignment:NSTextAlignmentCenter];
        [serviceNeedNumLab setFont:[UIFont systemFontOfSize:15]];
        [serviceNeedNumLab setTextColor:[UIColor blackColor]];
        [self addSubview:serviceNeedNumLab];

        addNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addNumBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addNumBtn setFrame:CGRectMake(MAIN_WIDTH-40,5, 40, 30)];
        [addNumBtn setImage:[UIImage imageNamed:@"goods_add"] forState:UIControlStateNormal];
        [self addSubview:addNumBtn];


        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:KEY_COMMON_CORLOR];
        [self addSubview:sep];
    }
    return self;
}

- (void)setSubType:(WarehouseSubTypeInfo *)subType
{
    _subType = subType;
    reduceBtn.hidden = !subType.m_isForSelect;
    serviceNeedNumLab.hidden = !subType.m_isForSelect;
    addNumBtn.hidden = !subType.m_isForSelect;
    [tip1 setText:[NSString stringWithFormat:@"%@(¥%@)",subType.m_name,subType.m_price]];
    [serviceNeedNumLab setText:subType.m_selectedNum.length == 0 ? @"0" : subType.m_selectedNum];
}


- (void)reduceBtnClicked:(UIButton *)btn
{
    NSInteger num = self.subType.m_selectedNum.integerValue;
    if(num > 0){
        num--;
    }
    self.subType.m_selectedNum = [NSString stringWithFormat:@"%lu",num];
    [self.m_delegate onReload];

}

- (void)addBtnClicked:(UIButton *)btn
{
    NSInteger num = self.subType.m_selectedNum.integerValue;
    num++;
    self.subType.m_selectedNum = [NSString stringWithFormat:@"%lu",num];
    [self.m_delegate onReload];
}

@end
