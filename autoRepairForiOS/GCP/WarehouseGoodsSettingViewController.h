//
//  WarehouseGoodsSettingViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/3.
//  Copyright © 2017年 Poitns. All rights reserved.
//

@protocol WarehouseGoodsSettingViewControllerDelegate <NSObject>

@required

- (void)onSelectGoodsType:(NSDictionary *)goodsInfo;

@end

#import "SpeRefreshAndLoadViewController.h"

@interface WarehouseTopTypeInfo :NSObject
@property(assign)BOOL m_isOpen;
@property(nonatomic,strong)NSDictionary *m_info;

@end

@interface WarehouseGoodsSettingViewController : SpeRefreshAndLoadViewController
@property(assign)BOOL m_isSelect;
@property(nonatomic,weak)id<WarehouseGoodsSettingViewControllerDelegate>m_selectDelegate;
- (id)initForSelectType;
@end
