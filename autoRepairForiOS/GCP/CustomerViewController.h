//
//  CustomerViewController.h
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"

@interface CustomerViewController : SpeRefreshAndLoadViewController

@property(nonatomic,assign)BOOL m_isAdd;
- (id)initForAddRepair;
@end
