//
//  CustomerViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "CustomerViewController.h"
#import "AddNewCustomerViewController.h"
#import "CustomerTableViewCell.h"
#import "AddRepairHistoryViewController.h"
@interface CustomerViewController()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation CustomerViewController

- (id)initForAddRepair
{
    self.m_isAdd = YES;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
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

- (id)init
{
    self.m_isAdd = NO;
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
    [self requestData:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if(!self.m_isAdd)
    {
        backBtn.hidden = YES;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-60, DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navigationBG addSubview:addBtn];
        [title setText:@"客户"];
    }
    else
    {
        [title setText:@"选择客户，添加纪录"];
    }

}

- (void)addBtnClicked
{
    AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    CustomerTableViewCell *cell = [[CustomerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    ADTContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    cell.infoData = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];

    if(self.m_isAdd)
    {
        ADTRepairInfo *data = [[ADTRepairInfo alloc]init];
        data.m_carCode = info.m_carCode;
        AddRepairHistoryViewController *vc = [[AddRepairHistoryViewController alloc]initWithInfo:data];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
 

}

- (void)requestData:(BOOL)isRefresh
{
    self.m_arrData = [DB_Shared quertAllCustoms];
    
    [self reloadDeals];
    
}

@end
