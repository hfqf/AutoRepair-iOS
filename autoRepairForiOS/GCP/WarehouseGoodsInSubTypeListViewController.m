//
//  WarehouseGoodsInSubTypeListViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsInSubTypeListViewController.h"
#import "WarehouseGoodsAddNewViewController.h"
#import "WarehouseGoodsInfoViewController.h"
#import "WarehouseGoodsTableViewCell.h"
@interface WarehouseGoodsInSubTypeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation WarehouseGoodsInSubTypeListViewController

-(id)initWith:(NSDictionary *)info
{
    self.m_parentInfo = info;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_parentInfo[@"name"]];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-90, DISTANCE_TOP,80, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)addBtnClicked
{
    WarehouseGoodsAddNewViewController *add = [[WarehouseGoodsAddNewViewController alloc]initWith:self.m_parentInfo];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllGoodsListWithType:self.m_parentInfo[@"_id"]
                        successedBlock:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        if([succeedResult[@"code"]integerValue] == 1)
        {
            NSArray *arr = succeedResult[@"ret"];

            NSMutableArray *arrRet = [NSMutableArray array];
            for(NSDictionary *_info in arr){
                WareHouseGoods *goods = [WareHouseGoods from:_info];
                [arrRet addObject:goods];
            }
            self.m_arrData = arrRet;
        }
        [self reloadDeals];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self reloadDeals];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define HIGH_CELL  60
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH_CELL;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    WarehouseGoodsTableViewCell *cell = [[WarehouseGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    WareHouseGoods *info = [self.m_arrData objectAtIndex:indexPath.row];
    cell.infoData = info;
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WareHouseGoods *info = [self.m_arrData objectAtIndex:indexPath.row];
    WarehouseGoodsInfoViewController *sub = [[WarehouseGoodsInfoViewController alloc]initWith:info];
    [self.navigationController pushViewController:sub animated:YES];
}

@end
