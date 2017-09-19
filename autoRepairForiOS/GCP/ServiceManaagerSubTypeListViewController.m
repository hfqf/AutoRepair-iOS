//
//  ServiceManaagerSubTypeListViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ServiceManaagerSubTypeListViewController.h"
#import "ServiceManaagerSubTypeAddViewController.h"
@interface ServiceManaagerSubTypeListViewController ()

@end

@implementation ServiceManaagerSubTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_parentInfo[@"name"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)addBtnClicked
{
    ServiceManaagerSubTypeAddViewController *add = [[ServiceManaagerSubTypeAddViewController alloc]initWith:self.m_parentInfo];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
        [self showWaitingView];
        [HTTP_MANAGER getAllServiceSubTypeList:self.m_parentInfo[@"_id"]
                              successedBlock:^(NSDictionary *succeedResult) {
                                  [self removeWaitingView];
                                  if([succeedResult[@"code"]integerValue] == 1)
                                  {
                                      self.m_arrData = succeedResult[@"ret"];
                                  }
                                  [self reloadDeals];

                              } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                  [self removeWaitingView];
                                  [self reloadDeals];
                              }];
}

@end
