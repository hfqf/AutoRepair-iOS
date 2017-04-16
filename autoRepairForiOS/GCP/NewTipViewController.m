//
//  NewTipViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "NewTipViewController.h"
#import "AddRepairHistoryViewController.h"
#import "CustomerViewController.h"
#import "RepairHistotyTableViewCell.h"
@interface NewTipViewController()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation NewTipViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    backBtn.hidden = YES;
    [title setText:@"到期记录"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-90, DISTANCE_TOP,80, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"添加纪录" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
    
    
    //登录完后的数据回来后再次刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forceRefresh) name:KEY_REPAIRS_SYNCED object:nil];
}

- (void)forceRefresh
{
    [self requestData:YES];
}


- (void)addBtnClicked
{
    CustomerViewController *vc = [[CustomerViewController  alloc]initForAddRepair];
    vc.m_delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    RepairHistotyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[RepairHistotyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    ADTRepairInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    cell.info = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTRepairInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    info.m_isAddNewRepair = NO;
    AddRepairHistoryViewController *vc = [[AddRepairHistoryViewController alloc]initWithInfo:info];
    vc.m_delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER queryAllTipedRepair:[LoginUserUtil userTel]
                       successedBlock:^(NSDictionary *succeedResult) {
                           
                           [self removeWaitingView];
                           if([succeedResult[@"code"]integerValue] == 1)
                           {
                               NSArray *arr = succeedResult[@"ret"];
                               NSMutableArray *_arrInsert = [NSMutableArray array];
                               for(NSDictionary *info in arr)
                               {
                                   ADTRepairInfo *rep = [ADTRepairInfo from:info];
                                   [_arrInsert addObject:rep];
                               }
                               self.m_arrData = _arrInsert;
                           }
                           else
                           {
                               [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                           }
                           [self reloadDeals];
                       }
                          failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                              [self removeWaitingView];
                              [self reloadDeals];
    }];
}


#pragma mark - BaseViewControllerDelegate

- (void)onRefreshParentData
{
    [self requestData:YES];
}
@end
