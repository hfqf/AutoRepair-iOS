//
//  WarehouseGoodsSettingSubTypeAddViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/3.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"

@interface WarehouseGoodsSettingSubTypeAddViewController : SpeRefreshAndLoadViewController
- (id)initWith:(NSDictionary *)info;
@property(nonatomic,strong)NSString *m_value1;
@property(nonatomic,strong)UITextField *m_currentTexfField;
@end
