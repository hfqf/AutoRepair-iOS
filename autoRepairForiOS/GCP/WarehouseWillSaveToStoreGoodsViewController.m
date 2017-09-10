//
//  WarehouseWillSaveToStoreGoodsViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseWillSaveToStoreGoodsViewController.h"

@interface WarehouseWillSaveToStoreGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@end

@implementation WarehouseWillSaveToStoreGoodsViewController

- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"待入库"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    //    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)addBtnClicked
{

    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"新增商品",@"商品分类设置",@"查看未启用商品", nil];
    [act showInView:self.view];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER queryPurchaseGoods:@"1"
                      successedBlock:^(NSDictionary *succeedResult) {
                          [self removeWaitingView];
                            if([succeedResult[@"code"]integerValue] == 1)
                            {
                                NSArray *arr = succeedResult[@"ret"];
                                NSMutableArray *arrRet = [NSMutableArray array];
                                for(NSDictionary *_info in arr){
                                    WarehousePurchaseInfo *info = [WarehousePurchaseInfo from:_info];
                                    [arrRet addObject:info];
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


#define HIGH_CELL  40
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH_CELL;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HIGH_CELL;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = navigationBG.backgroundColor;
    WarehousePurchaseInfo *info = [self.m_arrData objectAtIndex:indexPath.row];


    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsAddNewViewController") alloc]init] animated:YES];

    }else if (buttonIndex == 1){
        [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsSettingTopTypeListViewController") alloc]init] animated:YES];
    }else{
        
    }
}

@end

