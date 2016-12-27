//
//  SpeCommonTableView.h
//  xxt_xj
//
//  Created by Points on 13-12-18.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface SpeCommonTableView : UITableView
{
    
}
@property(nonatomic,retain) MJRefreshHeaderView *_header;
@property(nonatomic,retain) MJRefreshFooterView *_footer;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (id)initWithFrame:(CGRect)frame
              Style:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
 withViewController:(id<MJRefreshBaseViewDelegate>)VC;

@end