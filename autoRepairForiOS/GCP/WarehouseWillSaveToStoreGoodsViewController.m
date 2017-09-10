//
//  WarehouseWillSaveToStoreGoodsViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseWillSaveToStoreGoodsViewController.h"
#import "WarehouseWillSaveToStoreGoodsTableViewCell.h"
#import "WarehouseGoodPurchaseInfoViewController.h"
@interface WarehouseWillSaveToStoreGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WarehouseWillSaveToStoreGoodsTableViewCellDelegate>
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


#define HIGH_CELL  170

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH_CELL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    WarehouseWillSaveToStoreGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil){
        cell = [[WarehouseWillSaveToStoreGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.m_delegate  = self;
    WarehousePurchaseInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
    [cell setInfo:info];
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

#pragma mark - WarehouseWillSaveToStoreGoodsTableViewCellDelegate

- (void)onWarehouseWillSaveToStoreGoodsTableViewCellReject:(WarehousePurchaseInfo *)purchase
{

}

- (void)onWarehouseWillSaveToStoreGoodsTableViewCellCheckInfo:(WarehousePurchaseInfo *)purchase
{
    WarehouseGoodPurchaseInfoViewController *infoVc = [[WarehouseGoodPurchaseInfoViewController alloc]initWith:purchase];
    [self.navigationController pushViewController:infoVc animated:YES];
}

- (void)onWarehouseWillSaveToStoreGoodsTableViewCellSave:(WarehousePurchaseInfo *)purchase
{


}



@end

