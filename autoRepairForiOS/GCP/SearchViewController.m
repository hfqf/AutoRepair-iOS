//
//  SearchViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "SearchViewController.h"
#import "RepairHistotyTableViewCell.h"
#import "AddRepairHistoryViewController.h"
@interface SearchViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UISearchBar *m_searchBar;
}

@property(nonatomic,strong)ADTContacterInfo *m_contact;
@end
@implementation SearchViewController

- (id)initWith:(ADTContacterInfo *)contact
{
    self.m_contact = contact;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
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
    self = [super initWithStyle:UITableViewStyleGrouped withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES];
    if (self)
    {
        backBtn.hidden = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"可输入客户名,车牌号,号码查询记录"];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
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
    [title setText:@"查询维修记录"];

}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self requestData:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:YES];
}


- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];

    [HTTP_MANAGER queryAllRepair:[LoginUserUtil userTel]
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
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self reloadDeals];
    }];
    

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
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
