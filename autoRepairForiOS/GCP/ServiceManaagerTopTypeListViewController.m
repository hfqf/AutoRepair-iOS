//
//  ServiceManaagerTopTypeListViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ServiceManaagerTopTypeListViewController.h"
#import "ServiceManaagerSubTypeAddViewController.h"
@interface ServiceManaagerTopTypeListViewController ()

@end

@implementation ServiceManaagerTopTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"服务管理(设置大类)"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)addBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManaagerTopTypeAddViewController") alloc]init] animated:YES];

}

- (void)requestData:(BOOL)isRefresh
{
    [HTTP_MANAGER getAllServiceTopTypeList:^(NSDictionary *succeedResult) {
        if([succeedResult[@"code"]integerValue] == 1)
        {
            self.m_arrData = succeedResult[@"ret"];
        }
        [self reloadDeals];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self reloadDeals];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    ServiceManaagerSubTypeAddViewController *sub = [[ServiceManaagerSubTypeAddViewController alloc]initWith:info];
    [self.navigationController pushViewController:sub animated:YES];
}


@end
