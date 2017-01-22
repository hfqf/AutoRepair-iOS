//
//  TabbarBaseViewController.h
//  xxt_xj
//
//  Created by Points on 14-1-8.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface TabbarBaseViewController : BaseViewController
{
    UIImageView *m_bgView;
}
- (id)initWith:(BOOL)isNeedBottom;
- (id)init;
@end

