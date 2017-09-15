//
//  WarehouseSettingViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/8/27.
//  Copyright © 2017年 Poitns. All rights reserved.
//

@protocol WarehousePostionDelegate <NSObject>

@optional
- (void)onWarehousePositionSelected:(NSDictionary *)positionInfo;

@end
#import "SpeRefreshAndLoadViewController.h"

@interface WarehouseSettingViewController : SpeRefreshAndLoadViewController
@property(nonatomic,weak)id<WarehousePostionDelegate> m_selectDelegate;
- (id)initWith:(id<WarehousePostionDelegate>)delegate;

@end
