//
//  WarehouseGoodsInSubTypeListViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsInSubTypeListViewController.h"
#import "WarehouseGoodsInfoViewController.h"
#import "WarehouseGoodsTableViewCell.h"
@interface WarehouseGoodsInSubTypeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation WarehouseGoodsInSubTypeListViewController

- (id)initWithSelectDelegate:(id<WarehouseGoodsInSubTypeListViewControllerDelegate>)delegate withSelectedGoods:(NSArray *)arrSelected
{
    self.m_arrSelect = [NSMutableArray arrayWithArray:arrSelected];
    self.m_selecteDelegate = delegate;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

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
    [title setText:self.m_selecteDelegate == nil ? self.m_parentInfo[@"name"] : @"添加商品"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, 44)];
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

    if(self.m_selecteDelegate){

        NSMutableArray *arr = [NSMutableArray array];
        for(WareHouseGoods *good in self.m_arrData){
            if(good.m_isSelected){
                [arr addObject:good];
            }
        }
        [self.m_selecteDelegate onSelectGoodsArray:arr];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        WareHouseGoods *good = [[WareHouseGoods alloc]init];
        good.m_isAddNew = YES;
        good.m_category = self.m_parentInfo;
        WarehouseGoodsInfoViewController *add = [[WarehouseGoodsInfoViewController alloc]initWith:good];
        [self.navigationController pushViewController:add animated:YES];
    }

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
                goods.m_isSelectStyle = self.m_selecteDelegate != nil;

                for(WareHouseGoods *_good in self.m_arrSelect){
                    if([_good.m_id isEqualToString:goods.m_id]){
                        goods.m_isSelected = YES;
                    }else{
                        goods.m_isSelected = NO;
                    }
                }

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
    if(self.m_selecteDelegate){
        WareHouseGoods *info = [self.m_arrData objectAtIndex:indexPath.row];
        info.m_isSelected = !info.m_isSelected;
        [self reloadDeals];
    }else{

        WareHouseGoods *info = [self.m_arrData objectAtIndex:indexPath.row];
        WarehouseGoodsInfoViewController *sub = [[WarehouseGoodsInfoViewController alloc]initWith:info];
        [self.navigationController pushViewController:sub animated:YES];
    }

}

@end
