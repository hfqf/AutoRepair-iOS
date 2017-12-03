//
//  NewTipViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "NewTipViewController.h"
#import "AddRepairHistoryViewController.h"
#import "CustomerViewController.h"
#import "RepairHistotyTableViewCell.h"
#import "WorkroomAddOrEditViewController.h"
#import "ADTOrderInfo.h"
#import "NSDictionary+ValueCheck.m"
#import "AddNewCustomerViewController.h"
#import "ADTContacterInfo.h"
#import "CustomerTableViewCell.h"
@interface NewTipViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
     UIView *m_tipView;
}
@property(nonatomic,assign)NSInteger m_page;

@property(assign)NSInteger m_index;

@end
@implementation NewTipViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:NO];
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

}





- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"到期提醒"];

    [self createButtons];
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"到期工单",@"到期年审",@"到期保险"];

    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH/self.m_arrCategory.count, 40)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+36, MAIN_WIDTH/self.m_arrCategory.count, 4)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(m_tipView.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(m_tipView.frame))];
}

#pragma mark - private

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestData:YES];

    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == btn.tag)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(self.m_currentIndex*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}

- (void)forceRefresh
{
    [self requestData:YES];
}


- (void)addBtnClicked
{
    CustomerViewController *vc = [[CustomerViewController  alloc]initForAddRepair];
    vc.m_delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
#define WIDTH_LEFT  130

- (NSInteger)high:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 0){
        ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
        CGSize size = [FontSizeUtil sizeOfString:[NSString stringWithFormat:@"预约内容:%@",info.m_info] withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-WIDTH_LEFT-20];
        return size.height+80;
    }
     return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.m_currentIndex == 0 ? 120 : [self high:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 0){
        static NSString * identify = @"spe0";
        RepairHistotyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[RepairHistotyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }

        ADTRepairInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
        cell.info = info;
        return cell;
    }else{

        static NSString * identify = @"spe1";
        CustomerTableViewCell *cell = [[CustomerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        ADTContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
        cell.infoData = info;
        return cell;
    }
    return [[UITableViewCell alloc]init];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_currentIndex == 0){
        ADTRepairInfo *rep = [self.m_arrData objectAtIndex:indexPath.row];
        WorkroomAddOrEditViewController *add = [[WorkroomAddOrEditViewController alloc]initWith:rep];
        [self.navigationController pushViewController:add animated:YES];
    }else{

        ADTContacterInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
        AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:info];
        vc.m_delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)requestData:(BOOL)isRefresh
{
    self.m_arrData = nil;
    [self showWaitingView];
    if(self.m_currentIndex == 0){
        [HTTP_MANAGER queryAllTipedRepair:[LoginUserUtil userTel]
                           successedBlock:^(NSDictionary *succeedResult) {

                               [self removeWaitingView];
                               if([succeedResult[@"code"]integerValue] == 1)
                               {
                                   NSArray *arr = succeedResult[@"ret"];
                                   NSMutableArray *_arrInsert = [NSMutableArray array];
                                   for(NSDictionary *info in arr)
                                   {
                                       ADTRepairInfo *_rep = [ADTRepairInfo from:info];
                                       _rep.m_index = [NSString stringWithFormat:@"%ld", (long)[arr indexOfObject:info]+1];
                                       ADTContacterInfo *con = [DB_Shared contactWithCarCode:_rep.m_carCode withContactId:_rep.m_contactid];
                                       if(con){
                                           [_arrInsert addObject:_rep];
                                       }
                                   }
                                   self.m_arrData = _arrInsert;
                               }
                               else
                               {
                                   [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                               }
                               [self reloadDeals];
                           }
                              failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                  [self removeWaitingView];
                                  [self reloadDeals];
                              }];
    }else if(self.m_currentIndex == 1){
        [HTTP_MANAGER queryAllYearCheckTiped:[LoginUserUtil userTel]
                              successedBlock:^(NSDictionary *succeedResult) {
                                    [self removeWaitingView];
                                  if([succeedResult[@"code"]integerValue] == 1)
                                  {
                                      NSMutableArray *_arr = [NSMutableArray array];
                                      NSArray * arr = succeedResult[@"ret"];
                                      if(arr.count > 0)
                                      {
                                          for(NSDictionary *info in arr)
                                          {
                                              ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
                                              newCon.m_owner = info[@"owner"];
                                              newCon.m_carType = info[@"cartype"];
                                              newCon.m_carCode = [info stringWithFilted:@"carcode"];
                                              newCon.m_userName = info[@"name"];
                                              newCon.m_tel = info[@"tel"];
                                              newCon.m_idFromServer = info[@"_id"];
                                              newCon.m_strInsertTime = [info stringWithFilted:@"inserttime"];
                                              newCon.m_strIsBindWeixin = info[@"isbindweixin"];
                                              newCon.m_strWeixinOPneid = info[@"weixinopenid"];
                                              newCon.m_strVin = info[@"vin"];
                                              newCon.m_strCarRegistertTime = info[@"carregistertime"];
                                              newCon.m_strHeadUrl = info[@"headurl"];
                                              newCon.m_strSafeCompany = [[info stringWithFilted:@"safecompany"]length] == 0 ? @"" : [info stringWithFilted: @"safecompany"];
                                              newCon.m_strSafeNextTime = [[info stringWithFilted:@"safenexttime"]length] == 0? @"" : [info stringWithFilted: @"safenexttime"];
                                              newCon.m_strYearCheckNextTime = [[info stringWithFilted:@"yearchecknexttime"]length] == 0 ? @"" :[info stringWithFilted:@"yearchecknexttime"];
                                              [_arr addObject:newCon];
                                          }
                                      }
                                      self.m_arrData = _arr;
                                  }
                                  [self reloadDeals];


        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            [self removeWaitingView];
            [self reloadDeals];
        }];
    }else{
        [HTTP_MANAGER queryAllSafeTiped:[LoginUserUtil userTel]
                              successedBlock:^(NSDictionary *succeedResult) {
                                  [self removeWaitingView];
                                  if([succeedResult[@"code"]integerValue] == 1)
                                  {
                                      NSMutableArray *_arr = [NSMutableArray array];
                                      NSArray * arr = succeedResult[@"ret"];
                                      if(arr.count > 0)
                                      {
                                          for(NSDictionary *info in arr)
                                          {
                                              ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
                                              newCon.m_owner = info[@"owner"];
                                              newCon.m_carType = info[@"cartype"];
                                              newCon.m_carCode = [info stringWithFilted:@"carcode"];
                                              newCon.m_userName = info[@"name"];
                                              newCon.m_tel = info[@"tel"];
                                              newCon.m_idFromServer = info[@"_id"];
                                              newCon.m_strInsertTime = [info stringWithFilted:@"inserttime"];
                                              newCon.m_strIsBindWeixin = info[@"isbindweixin"];
                                              newCon.m_strWeixinOPneid = info[@"weixinopenid"];
                                              newCon.m_strVin = info[@"vin"];
                                              newCon.m_strCarRegistertTime = info[@"carregistertime"];
                                              newCon.m_strHeadUrl = info[@"headurl"];
                                              newCon.m_strSafeCompany = [[info stringWithFilted:@"safecompany"]length] == 0 ? @"" : [info stringWithFilted: @"safecompany"];
                                              newCon.m_strSafeNextTime = [[info stringWithFilted:@"safenexttime"]length] == 0? @"" : [info stringWithFilted: @"safenexttime"];
                                              newCon.m_strYearCheckNextTime = [[info stringWithFilted:@"yearchecknexttime"]length] == 0 ? @"" :[info stringWithFilted:@"yearchecknexttime"];
                                              [_arr addObject:newCon];
                                          }
                                      }
                                      self.m_arrData = _arr;
                                  }
                                  [self reloadDeals];


                              } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                  [self removeWaitingView];
                                  [self reloadDeals];
                              }];
    }

}


#pragma mark - BaseViewControllerDelegate

- (void)onRefreshParentData
{
    [self requestData:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:self.m_index];
    ADTContacterInfo *con = [DB_Shared contactWithOpenId:info.m_openid];
    if(actionSheet.numberOfButtons == 4){
        if(buttonIndex == 0){
            [self delOrder];
        }else if (buttonIndex == 1){
            AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:con];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 2){
            [self startRepair:con];
        }
    }else{
        if(buttonIndex == 0){
            [self updateOrder];
        }else if (buttonIndex == 1){
            [self delOrder];
        }else if (buttonIndex == 2){
            AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:con];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 3){
            [self startRepair:con];
        }
    }
}

- (void)startRepair:(ADTContacterInfo *)contact
{
    ADTOrderInfo *order = [self.m_arrData objectAtIndex:self.m_index];
    ADTRepairInfo *rep = [ADTRepairInfo initWith:contact];
    rep.m_repairType =order.m_info;
    [self showWaitingView];
    [HTTP_MANAGER addNewRepair4:rep
                 successedBlock:^(NSDictionary *succeedResult) {
                     [self removeWaitingView];
                     rep.m_idFromNode = succeedResult[@"ret"][@"_id"];
                     rep.m_state = @"0";
                     rep.m_owner = [LoginUserUtil userTel];

                     if([succeedResult[@"code"]integerValue] == 1)
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"开单成功" inSuperView:self.view  withDuration:1];
                         WorkroomAddOrEditViewController *add = [[WorkroomAddOrEditViewController alloc]initWith:rep];
                         [self.navigationController pushViewController:add animated:YES];
                     }
                     else
                     {
                         [PubllicMaskViewHelper showTipViewWith:@"开单失败" inSuperView:self.view  withDuration:1];
                     }

                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                     [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:@"开单失败" inSuperView:self.view  withDuration:1];

                 }];
}
- (void)updateOrder
{
    [self showWaitingView];
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:self.m_index];
    [HTTP_MANAGER updateCustomerOrderWith:[LoginUserUtil shopName]
                               withOpenId:info.m_openid
                                   withId:info.m_id
                          withConfirmTime:info.m_confirmtime
                            withOrderTime:info.m_time
                            withOrderInfo:info.m_info
                                withState:@"1"
                           successedBlock:^(NSDictionary *succeedResult) {
                               [self removeWaitingView];
                               [self requestData:YES];

                           } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                               [self removeWaitingView];

                           }];
}

- (void)delOrder
{
    [self showWaitingView];
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:self.m_index];
    [HTTP_MANAGER delCustomerOrder:info.m_id
                    successedBlock:^(NSDictionary *succeedResult) {
                        [self removeWaitingView];
                        [self requestData:YES];

                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                        [self removeWaitingView];
                    }];
}
@end
