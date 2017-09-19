//
//  ServiceManagerViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ServiceManagerViewController.h"
#import "ServiceManaagerSubTypeListViewController.h"
@interface ServiceManagerViewController ()<UIActionSheetDelegate>

@end

@implementation ServiceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"服务管理"];
}


- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"新增服务",@"服务分类设置", nil];
    [act showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllServiceTypePreviewList:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        if([succeedResult[@"code"]integerValue] == 1)
        {
            NSArray *arr = succeedResult[@"ret"];
            NSMutableArray *arrRet = [NSMutableArray array];
            for(NSDictionary *_info in arr){
                WarehouseTopTypeInfo *info = [[WarehouseTopTypeInfo alloc]init];
                info.m_info = _info;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *arr = info.m_info[@"subtype"];

    NSDictionary *_info = [arr objectAtIndex:indexPath.row];
    if(self.m_isSelect){
        [self.m_selectDelegate onSelectGoodsType:_info];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        ServiceManaagerSubTypeListViewController *list = [[ServiceManaagerSubTypeListViewController alloc]initWith:_info];
        [self.navigationController pushViewController:list animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManaagerTopTypeAddViewController") alloc]init] animated:YES];

    }else if (buttonIndex == 1){
        [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManaagerTopTypeListViewController") alloc]init] animated:YES];
    }else{

    }
}

@end
