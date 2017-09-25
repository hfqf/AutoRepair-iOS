//
//  WarehouseSelectGoodsToRepairViewController.h
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/23.
//  Copyright © 2017年 Poitns. All rights reserved.
//


@protocol WarehouseSelectGoodsToRepairViewControllerDelegate<NSObject>

@required
- (void)onWarehouseSelectGoodsToRepairViewControllerSelected:(NSArray *)arrGoods;
@end
#import "SpeRefreshAndLoadViewController.h"


@interface WarehouseSelectGoodsToRepairViewController : SpeRefreshAndLoadViewController
@property(nonatomic,weak)id<WarehouseSelectGoodsToRepairViewControllerDelegate>m_selectDelegate;
- (id)initWithSelected:(NSMutableDictionary *)selectedDic;
@end
