//
//  WarehouseGoodsInSubTypeListViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

@protocol WarehouseGoodsInSubTypeListViewControllerDelegate <NSObject>

@required
- (void)onSelectGoodsArray:(NSArray *)arrSelected;

@end
#import "SpeRefreshAndLoadViewController.h"

@interface WarehouseGoodsInSubTypeListViewController : SpeRefreshAndLoadViewController
@property(nonatomic,weak)id<WarehouseGoodsInSubTypeListViewControllerDelegate>m_selecteDelegate;
- (id)initWith:(NSDictionary *)info;

- (id)initWithSelectDelegate:(id<WarehouseGoodsInSubTypeListViewControllerDelegate>)delegate withSelectedGoods:(NSArray *)arrSelected;
@end
