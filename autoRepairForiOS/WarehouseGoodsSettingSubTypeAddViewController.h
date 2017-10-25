//
//  WarehouseGoodsSettingSubTypeAddViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/3.
//  Copyright © 2017年 Poitns. All rights reserved.
//


#import "SpeRefreshAndLoadViewController.h"
@protocol WarehouseGoodsSettingSubTypeAddViewControllerDelegate<NSObject>

- (void)onRefreshTopInfo:(NSArray *)arrSubIds;

@end

@interface WarehouseGoodsSettingSubTypeAddViewController : SpeRefreshAndLoadViewController
- (id)initWith:(NSDictionary *)info;
- (id)initWithForEdit:(NSDictionary *)info;
@property(nonatomic,strong)NSString *m_value1;
@property(nonatomic,strong)UITextField *m_currentTexfField;
@property(nonatomic,weak)id<WarehouseGoodsSettingSubTypeAddViewControllerDelegate>m_refreshDelegate;
@end
