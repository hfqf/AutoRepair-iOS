//
//  OwnValueViewController.h
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/26.
//  Copyright © 2017年 Poitns. All rights reserved.
//
@protocol OwnValueViewControllerDelegate<NSObject>
@required
- (void)onOwnValueViewController:(NSInteger)ownMoney;
@end

#import "SpeRefreshAndLoadViewController.h"

@interface OwnValueViewController : SpeRefreshAndLoadViewController
@property(nonatomic,weak)id<OwnValueViewControllerDelegate>m_ownDelegate;
@end
