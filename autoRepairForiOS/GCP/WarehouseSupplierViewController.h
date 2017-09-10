//
//  WarehouseSupplierViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/8/28.
//  Copyright © 2017年 Poitns. All rights reserved.
//
@protocol WarehouseSupplierViewControllerDelegate <NSObject>

@required

- (void)onSupplierSelected:(NSDictionary *)supplier;

@end
#import "SpeRefreshAndLoadViewController.h"

@interface WarehouseSupplierViewController : SpeRefreshAndLoadViewController

- (id)initWith:(id<WarehouseSupplierViewControllerDelegate>)delegate;
@end
