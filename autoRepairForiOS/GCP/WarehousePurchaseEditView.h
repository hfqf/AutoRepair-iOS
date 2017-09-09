//
//  WarehousePurchaseEditView.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/9.
//  Copyright © 2017年 Poitns. All rights reserved.
//

@protocol WarehousePurchaseEditViewDelegate <NSObject>

@required

- (void)onEditCompleted:(WareHouseGoods *)newGoods;

@end

#import <UIKit/UIKit.h>


@interface WarehousePurchaseEditView : UIView<UITextFieldDelegate>
{
    UITextField *m_priceTextField;
    UITextField *m_numTextField;
}

@property(nonatomic,weak)id<WarehousePurchaseEditViewDelegate>m_delegate;
@property(nonatomic,strong)WareHouseGoods *m_goods;

- (id)initWith:(WareHouseGoods *)goods withDelegate:(id<WarehousePurchaseEditViewDelegate>)delegate;

@end
