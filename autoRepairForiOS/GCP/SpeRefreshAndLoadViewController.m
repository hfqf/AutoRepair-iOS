//
//  SpeRefreshAndLoadViewController.m
//  xxt_xj
//
//  Created by Points on 13-12-10.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
@interface SpeRefreshAndLoadViewController ()


@end

@implementation SpeRefreshAndLoadViewController

- (void)dealloc
{
    self.m_arrData = nil;
    self.m_emptyView = nil;
    
    self.tableView._header.delegate = nil;
    self.tableView._footer.delegate = nil;
    
 
    [self.tableView._header.scrollView removeObserver:self.tableView._header forKeyPath:@"contentOffset"];
    [self.tableView._footer.scrollView removeObserver:self.tableView._footer forKeyPath:@"contentOffset"];
    
    
    self.tableView._header.scrollView = nil;
    self.tableView._footer.scrollView = nil;
    
    self.tableView = nil;

    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
{
    self = [super init];
    if(self)
    {
        SpeCommonTableView * table =  [[SpeCommonTableView alloc]initWithFrame:CGRectMake(0, DISTANCE_TOP+HEIGHT_NAVIGATION, MAIN_WIDTH, MAIN_HEIGHT-DISTANCE_TOP-HEIGHT_NAVIGATION-(isNeedBottom?(OS_ABOVE_IOS7?HEIGHT_MAIN_BOTTOM:HEIGHT_MAIN_BOTTOM+20):OS_ABOVE_IOS7 ? 0:20)) Style:style withIsNeedPullDown:isNeedPullDownRefresh withIsNeedPullUpLoadMore:isNeesLoadMore withIsNeedBottobBar:isNeedBottom  withViewController:self];
        
        
        UIView *bg = [[UIView alloc]initWithFrame:table.bounds];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [table setBackgroundView:bg];
        [bg release];
        
        self.tableView = table;
        
        
        [table release];
        [self.view addSubview:self.tableView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
 withIsNeedPullDown:(BOOL)isNeedPullDownRefresh
withIsNeedPullUpLoadMore:(BOOL)isNeesLoadMore
withIsNeedBottobBar:(BOOL)isNeedBottom
withIsCustomNavigatiionHeight:(int)customNavHeight
{
    self = [super init];
    if(self)
    {
        SpeCommonTableView * table =  [[SpeCommonTableView alloc]initWithFrame:CGRectMake(0, DISTANCE_TOP+customNavHeight, MAIN_WIDTH, MAIN_HEIGHT-DISTANCE_TOP-customNavHeight-(isNeedBottom?(OS_ABOVE_IOS7?HEIGHT_MAIN_BOTTOM:HEIGHT_MAIN_BOTTOM+20):OS_ABOVE_IOS7 ? 0:20)) Style:style withIsNeedPullDown:isNeedPullDownRefresh withIsNeedPullUpLoadMore:isNeesLoadMore withIsNeedBottobBar:isNeedBottom  withViewController:self];
        
        UIView *bg = [[UIView alloc]initWithFrame:table.bounds];
        [bg setBackgroundColor:[UIColor whiteColor]];
        [table setBackgroundView:bg];
        [bg release];
        
        self.tableView = table;
        [table release];
        
        [self.view addSubview:table];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.tableView._header)
    {
        [ self.tableView._header performSelector:@selector(beginRefreshing) withObject:nil afterDelay:0];
    }
      EmptyTipView *empty = [[EmptyTipView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame))];
    self.m_emptyView = empty;
    [empty release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self.tableView._header performSelector:@selector(endRefreshing) withObject:nil afterDelay:30.0];
    if (refreshView == self.tableView._header)
    { // 下拉刷新
        [self requestData:YES];
    }
    else
    {
        [self requestData:NO];
    }
}


- (void)startRequestData:(MJRefreshBaseView *)pt
{
    if([pt isMemberOfClass:[MJRefreshHeaderView class]])
    {
        [self removeEmptyView];
        [self requestData:YES];
    }
    else
    {
        [self requestData:NO];
    }
}


#pragma mark - 需要子类实现
/*
 *
 * isRefresh : YES, 是下拉刷新;NO是上拉加载
 */
- (void)requestData:(BOOL)isRefresh
{
    //这两个方法可以控制当前视图还可不可以触发下拉或上拉的回调,
    //适用需求说当数据到底时不要在请求数据
    //self.tableView._footer.hidden = YES;
    //self.tableView._footer.hidden = NO;
    
    
}



#pragma mark 刷新
- (void)reloadDeals
{
    // 结束刷新状态
    [self.tableView._header endRefreshing];
    [self.tableView._footer endRefreshing];
    [self.tableView reloadData];
}

- (void)endRefreshing;
{
    if(self.tableView._header) {
        [self.tableView._header endRefreshing];
    }
}

//右滑
- (void)Swipe:(UISwipeGestureRecognizer *)gest
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(dragWithDirect:withCurrentTabIndex:)])
    {
        [self.m_delegate dragWithDirect:gest.direction withCurrentTabIndex:(int)self.view.tag];
    }
}

- (void)onShowSliderView
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onShowSliderView)])
    {
        [self.m_delegate onShowSliderView];
    }
}

- (void)showEmptyView
{
    if(![self.m_emptyView isDescendantOfView:self.view])
    {
        [self.view addSubview:self.m_emptyView];
    }
}

- (void)removeEmptyView
{
    if([self.m_emptyView isDescendantOfView:self.view])
    {
        [self.m_emptyView removeFromSuperview];
    }
}

- (void)showEmptyWith:(NSString *)tip
{
    [self removeEmptyView];
    CGRect rect = self.tableView.tableHeaderView.frame;
    EmptyTipView *empty = [[EmptyTipView alloc]initWithFrame:CGRectMake(0,self.tableView.tableHeaderView ? rect.size.height : 0 , MAIN_WIDTH, self.tableView.frame.size.height-(self.tableView.tableHeaderView ? rect.size.height : 0)) WithTip:tip];
    [empty setBackgroundColor:[UIColor whiteColor]];
    self.m_emptyView = empty;
    [empty release];
    
    if(![self.m_emptyView isDescendantOfView:self.view])
    {
        [self.tableView addSubview:self.m_emptyView];
    }
}

- (void)showOrderEmptyView
{
    [self removeEmptyView];
    NSString *tip = @"暂无订单,下拉刷新";
    CGRect rect = self.tableView.tableHeaderView.frame;
    EmptyTipView *empty = [[EmptyTipView alloc]initWithOrderFrame:CGRectMake(0,self.tableView.tableHeaderView ? rect.size.height : 0 , MAIN_WIDTH, self.tableView.frame.size.height-(self.tableView.tableHeaderView ? rect.size.height : 0)) WithTip:tip];
    [empty setBackgroundColor:UIColorFromRGB(0Xf0f0f0)];
    self.m_emptyView = empty;
    [empty release];
    
    if(![self.m_emptyView isDescendantOfView:self.view])
    {
        [self.tableView addSubview:self.m_emptyView];
    }
}

@end
