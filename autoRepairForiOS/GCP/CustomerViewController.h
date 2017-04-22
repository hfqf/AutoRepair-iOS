//
//  CustomerViewController.h
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

@protocol CustomerViewControllerDelegate <NSObject>

@required
- (void)onSelectContact:(ADTContacterInfo *)contact;
@end

#import "SpeRefreshAndLoadViewController.h"

@interface CustomerViewController : SpeRefreshAndLoadViewController

@property(nonatomic,assign)BOOL m_isAdd;

@property(nonatomic,weak)id<CustomerViewControllerDelegate>m_selectDelegate;
- (id)initForAddRepair;

- (void)addBtnClicked;

- (id)initForSelectContact:(NSString *)key;
@end
