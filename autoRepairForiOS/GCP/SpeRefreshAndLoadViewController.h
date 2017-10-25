//
//  SpeRefreshAndLoadViewController.h
//  xxt_xj
//
//  Created by Points on 13-12-10.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeCommonTableView.h"
#import "BaseViewController.h"
#import "EmptyTipView.h"

@interface SpeRefreshAndLoadViewController : BaseViewController<MJRefreshBaseViewDelegate>
{
    
}

@property (nonatomic,retain) SpeCommonTableView *tableView;
@property (nonatomic,retain) EmptyTipView *m_emptyView;
@property (nonatomic,assign) BOOL  m_isNeedNoneView;
@property (nonatomic,assign) BOOL  m_isRequesting;
@property (nonatomic,copy) NSArray *m_arrData;
@property (nonatomic,strong) NSMutableDictionary *m_parentInfo;
@property (nonatomic,copy) NSMutableDictionary *m_currentInfo;



- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom;

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
withIsNeedNoneView:(BOOL)isNeedNoneView;

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
withIsCustomNavigatiionHeight:(int)customNavHeight
;

/**
 *
 * isRefresh : YES, 是下拉刷新;NO是上拉加载
 */
- (void)requestData:(BOOL)isRefresh;

//刷新界面
- (void)reloadDeals;

//显示无数据时的提醒界面
- (void)showEmptyView;

 //移除提醒界面
- (void)removeEmptyView;

/**
 *  停止下拉加载
 */
- (void)endRefreshing;

- (void)showEmptyWith:(NSString *)tip;

- (void)showOrderEmptyView;
@end
