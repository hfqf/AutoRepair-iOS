//
//  ServiceManaagerTopTypeAddViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ServiceManaagerTopTypeAddViewController.h"

@interface ServiceManaagerTopTypeAddViewController ()

@end

@implementation ServiceManaagerTopTypeAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addBtnClicked
{
    [self.m_currentTexfField resignFirstResponder];
    if(self.m_value1.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"类名不能为空" inSuperView:self.view withDuration:1];
        return;
    }


    [self showWaitingView];
    [HTTP_MANAGER addNewServiceTopTypeWith:self.m_value1
                          successedBlock:^(NSDictionary *succeedResult) {
                              [self removeWaitingView];
                              if([succeedResult[@"code"]integerValue] == 1){
                                  [self.navigationController popViewControllerAnimated:YES];
                              }else{
                                  [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                              }

                          } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                              [self removeWaitingView];
                              [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];

                          }];
}


@end
