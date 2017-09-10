//
//  WarehouseWillSaveToStoreGoodsTableViewCell.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

@protocol WarehouseWillSaveToStoreGoodsTableViewCellDelegate <NSObject>

@required

- (void)onWarehouseWillSaveToStoreGoodsTableViewCellCheckInfo:(WarehousePurchaseInfo *)purchase;

- (void)onWarehouseWillSaveToStoreGoodsTableViewCellReject:(WarehousePurchaseInfo *)purchase;

- (void)onWarehouseWillSaveToStoreGoodsTableViewCellSave:(WarehousePurchaseInfo *)purchase;

@end
#import <UIKit/UIKit.h>

@interface WarehouseWillSaveToStoreGoodsTableViewCell : UITableViewCell
{
    UIButton *m_selectBtn;
    UILabel *m_supplierLab;
    UILabel  *m_priceLab;
    UILabel *m_expressIdLab;
    UILabel *m_expressCompanyLab;
    UILabel *m_timeLab;

    EGOImageView *m_icon;
    UILabel *m_goodNameLab;
    UILabel *m_sencodeLab;
    UILabel *m_numLab;

    UIView *m_sep;

    UIButton *m_checkBtn;
    UIButton *m_rejectBtn;
    UIButton *m_saveBtn;



}
@property(nonatomic,weak)id<WarehouseWillSaveToStoreGoodsTableViewCellDelegate>m_delegate;
@property(nonatomic,strong)WarehousePurchaseInfo *m_purchaseInfo;
- (void)setInfo:(WarehousePurchaseInfo *)info;
@end
