//
//  WarehouseWillSaveToStoreGoodsTableViewCell.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseWillSaveToStoreGoodsTableViewCell.h"

@implementation WarehouseWillSaveToStoreGoodsTableViewCell

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
    if(self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]){

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
//        m_selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [m_selectBtn setFrame:CGRectMake(5, 5, 30, 30)];
//        [m_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//        [self addSubview:m_selectBtn];

        m_supplierLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, MAIN_WIDTH-40-100, 16)];
        [m_supplierLab setBackgroundColor:[UIColor clearColor]];
        [m_supplierLab setTextAlignment:NSTextAlignmentLeft];
        [m_supplierLab setTextColor:[UIColor blackColor]];
        [m_supplierLab setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:m_supplierLab];

        m_priceLab = [[UILabel alloc]initWithFrame:CGRectMake(150, 5,MAIN_WIDTH-160, 16)];
        [m_priceLab setBackgroundColor:[UIColor clearColor]];
        [m_priceLab setTextAlignment:NSTextAlignmentRight];
        [m_priceLab setTextColor:KEY_COMMON_BLUE_CORLOR];
        [m_priceLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_priceLab];

        m_expressIdLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, MAIN_WIDTH-40, 16)];
        [m_expressIdLab setBackgroundColor:[UIColor clearColor]];
        [m_expressIdLab setTextAlignment:NSTextAlignmentLeft];
        [m_expressIdLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [m_expressIdLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_expressIdLab];

        m_expressCompanyLab = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(m_expressIdLab.frame)+5, MAIN_WIDTH-40, 16)];
        [m_expressCompanyLab setBackgroundColor:[UIColor clearColor]];
        [m_expressCompanyLab setTextAlignment:NSTextAlignmentLeft];
        [m_expressCompanyLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [m_expressCompanyLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_expressCompanyLab];

        m_timeLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120,CGRectGetMaxY(m_expressIdLab.frame)+5, 110, 16)];
        [m_timeLab setBackgroundColor:[UIColor clearColor]];
        [m_timeLab setTextAlignment:NSTextAlignmentRight];
        [m_timeLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [m_timeLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_timeLab];

        m_icon = [[EGOImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(m_expressCompanyLab.frame)+10, 50, 50)];
        [self addSubview:m_icon];

        m_goodNameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_icon.frame)+5,CGRectGetMaxY(m_expressCompanyLab.frame)+10, MAIN_WIDTH-(CGRectGetMaxX(m_icon.frame)+5), 16)];
        [m_goodNameLab setBackgroundColor:[UIColor clearColor]];
        [m_goodNameLab setTextAlignment:NSTextAlignmentLeft];
        [m_goodNameLab setTextColor:[UIColor blackColor]];
        [m_goodNameLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:m_goodNameLab];

        m_sencodeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_icon.frame)+5,CGRectGetMaxY(m_goodNameLab.frame)+20, MAIN_WIDTH-(CGRectGetMaxX(m_icon.frame)+5)-80, 16)];
        [m_sencodeLab setBackgroundColor:[UIColor clearColor]];
        [m_sencodeLab setTextAlignment:NSTextAlignmentLeft];
        [m_sencodeLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [m_sencodeLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_sencodeLab];

        m_numLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-90,CGRectGetMaxY(m_goodNameLab.frame)+20,80, 16)];
        [m_numLab setBackgroundColor:[UIColor clearColor]];
        [m_numLab setTextAlignment:NSTextAlignmentRight];
        [m_numLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [m_numLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:m_numLab];

        m_sep = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_icon.frame)+10, MAIN_WIDTH, 0.5)];
        [m_sep setBackgroundColor:UIColorFromRGB(0xDDDDDD)];
        [self addSubview:m_sep];

        m_checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_checkBtn setFrame:CGRectMake(5, CGRectGetMaxY(m_sep.frame), 100, 40)];
        [m_checkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [m_checkBtn setTitle:@"查看明细" forState:UIControlStateNormal];
        [m_checkBtn setTitleColor:KEY_COMMON_BLUE_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_checkBtn];
        [m_checkBtn addTarget:self action:@selector(checkBtnClicked) forControlEvents:UIControlEventTouchUpInside];

        m_saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_saveBtn setFrame:CGRectMake(MAIN_WIDTH-120, CGRectGetMaxY(m_sep.frame), 40, 40)];
        [m_saveBtn setTitle:@"入库" forState:UIControlStateNormal];
        [m_saveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [m_saveBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_saveBtn];
        [m_saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];

        m_rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_rejectBtn setFrame:CGRectMake(MAIN_WIDTH-40, CGRectGetMaxY(m_sep.frame), 40, 40)];
        [m_rejectBtn setTitle:@"撤单" forState:UIControlStateNormal];
        [m_rejectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [m_rejectBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
        [self addSubview:m_rejectBtn];
        [m_rejectBtn addTarget:self action:@selector(rejectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)saveBtnClicked
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onWarehouseWillSaveToStoreGoodsTableViewCellSave:)]){
        [self.m_delegate onWarehouseWillSaveToStoreGoodsTableViewCellSave:self.m_purchaseInfo];
    }
}

- (void)rejectBtnClicked
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onWarehouseWillSaveToStoreGoodsTableViewCellReject:)]){
        [self.m_delegate onWarehouseWillSaveToStoreGoodsTableViewCellReject:self.m_purchaseInfo];
    }
}

- (void)checkBtnClicked
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onWarehouseWillSaveToStoreGoodsTableViewCellCheckInfo:)]){
        [self.m_delegate onWarehouseWillSaveToStoreGoodsTableViewCellCheckInfo:self.m_purchaseInfo];
    }
}

- (void)setInfo:(WarehousePurchaseInfo *)info
{
    self.m_purchaseInfo = info;
    [m_selectBtn setImage:[UIImage imageNamed:info.m_isSelected ? @"check_on" : @"check_un"] forState:UIControlStateNormal];
    WareHouseGoods *good = [info.m_arrGoods firstObject];
    [m_supplierLab setText:info.m_supplierInfo.m_companyName];
    [m_expressIdLab setText:[NSString stringWithFormat:@"物流单号:%@",info.m_expressSerialId]];
    [m_priceLab setText:[NSString stringWithFormat:@"合计: %lu",good.m_purchaseNum.integerValue *good.m_costprice.integerValue]];

    [m_expressCompanyLab setText:[NSString stringWithFormat:@"物流公司:%@",info.m_expressCompany]];
    [m_timeLab setText:info.m_time.length > 10 ? [info.m_time substringToIndex:10] :info.m_time];

    [m_icon setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:good.m_picurl] ]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [m_goodNameLab setText:good.m_name];
    [m_sencodeLab setText:[NSString stringWithFormat:@"编码:%@",good.m_goodsencode]];
    [m_numLab setText:[NSString stringWithFormat:@"x%@",good.m_purchaseNum]];

}


@end
