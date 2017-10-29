//
//  NewTip2ViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/10/28.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "NewTip2ViewController.h"
#import "AddRepairHistoryViewController.h"
#import "CustomerViewController.h"
#import "RepairHistotyTableViewCell.h"
#import "WorkroomAddOrEditViewController.h"
#import "ADTOrderInfo.h"
#import "NSDictionary+ValueCheck.m"
#import "AddNewCustomerViewController.h"
@interface NewTip2ViewController()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIView *m_tipView;
}
@property (nonatomic,strong) NSArray *m_arrCategory;

@property (nonatomic,strong) NSArray *m_arrBtn;

@property(nonatomic,assign)NSInteger m_currentIndex;

@property(nonatomic,assign)NSInteger m_page;

@property(assign)NSInteger m_index;

@end
@implementation NewTip2ViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
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
//    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(m_tipView.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(m_tipView.frame)-HEIGHT_MAIN_BOTTOM)];

}





- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"预约提醒"];


//    [self createButtons];
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"工单提醒",@"预约提醒"];

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
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(m_tipView.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(m_tipView.frame)-HEIGHT_MAIN_BOTTOM)];
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
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    CGSize size = [FontSizeUtil sizeOfString:[NSString stringWithFormat:@"预约内容:%@",info.m_info] withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-WIDTH_LEFT-20];
    return size.height+80;
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
        static NSString * identify = @"spe";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, WIDTH_LEFT, 18)];
        [lab1 setBackgroundColor:[UIColor clearColor]];
        [lab1 setTextAlignment:NSTextAlignmentLeft];
        [lab1 setFont:[UIFont systemFontOfSize:14]];
        [lab1 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab1];

        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 27, WIDTH_LEFT, 18)];
        [lab2 setBackgroundColor:[UIColor clearColor]];
        [lab2 setTextAlignment:NSTextAlignmentLeft];
        [lab2 setFont:[UIFont systemFontOfSize:14]];
        [lab2 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab2];

        UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(5,50, WIDTH_LEFT, 18)];
        [lab3 setBackgroundColor:[UIColor clearColor]];
        [lab3 setTextAlignment:NSTextAlignmentLeft];
        [lab3 setFont:[UIFont systemFontOfSize:14]];
        [lab3 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab3];

        UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(5,70, WIDTH_LEFT, 18)];
        [lab4 setBackgroundColor:[UIColor clearColor]];
        [lab4 setTextAlignment:NSTextAlignmentLeft];
        [lab4 setFont:[UIFont systemFontOfSize:15]];
        [lab4 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab4];

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(WIDTH_LEFT+5,0, 0.5, [self high:indexPath])];
        [sep setBackgroundColor:KEY_COMMON_GRAY_CORLOR];
        sep.hidden = YES;
        [cell addSubview:sep];

        UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_LEFT+6,5, MAIN_WIDTH-WIDTH_LEFT-20, 18)];
        [lab5 setBackgroundColor:[UIColor clearColor]];
        [lab5 setTextAlignment:NSTextAlignmentLeft];
        [lab5 setFont:[UIFont systemFontOfSize:15]];
        [lab5 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab5];

        ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
        ADTContacterInfo *con = [DB_Shared contactWithOpenId:info.m_openid];
        CGSize size = [FontSizeUtil sizeOfString:[NSString stringWithFormat:@"预约内容:%@",info.m_info] withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-WIDTH_LEFT-20];

        UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_LEFT+6,30, MAIN_WIDTH-WIDTH_LEFT-20, size.height)];
        lab6.numberOfLines = 0;
        [lab6 setBackgroundColor:[UIColor clearColor]];
        [lab6 setTextAlignment:NSTextAlignmentLeft];
        [lab6 setFont:[UIFont systemFontOfSize:15]];
        [lab6 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab6];

        UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_LEFT+6,CGRectGetMaxY(lab6.frame)+20, MAIN_WIDTH-WIDTH_LEFT-20, 18)];
        [lab7 setBackgroundColor:[UIColor clearColor]];
        [lab7 setTextAlignment:NSTextAlignmentLeft];
        [lab7 setFont:[UIFont systemFontOfSize:11]];
        [lab7 setTextColor:[UIColor blackColor]];
        [cell addSubview:lab7];


        [lab1 setText:[NSString stringWithFormat:@"客户:%@",con.m_userName]];
        [lab2 setText:[NSString stringWithFormat:@"车牌:%@",con.m_carCode]];
        [lab3 setText:[NSString stringWithFormat:@"车型:%@",con.m_carType]];
        [lab4 setText:info.m_state.integerValue == 1 ?@"已处理":@"未处理"];
        [lab4 setTextColor:info.m_state.integerValue == 1 ?KEY_COMMON_LIGHT_BLUE_CORLOR : [UIColor blackColor]];
        [lab5 setText:[NSString stringWithFormat:@"预约时间:%@",info.m_time]];
        [lab6 setText:[NSString stringWithFormat:@"预约内容:%@",info.m_info]];
        [lab7 setText:[NSString stringWithFormat:@"提交时间:%@",info.m_inserttime]];
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
        self.m_index = indexPath.row;
        ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.row];
        if(info.m_state.integerValue == 1){
            UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"直接删除",@"查看该客户详情",@"开单", nil];
            [act showInView:self.view];
        }else{
            UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设置为已读,并发微信通知给客户",@"直接删除",@"查看该客户详情",@"开单", nil];
            [act showInView:self.view];
        }
    }

}

- (void)requestData:(BOOL)isRefresh
{
    self.m_currentIndex = 1;
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
    }else{
        [HTTP_MANAGER queryCustomerOrders:^(NSDictionary *succeedResult) {
            [self removeWaitingView];
            if([succeedResult[@"code"]integerValue] == 1){
                NSMutableArray *_arr = [NSMutableArray array];
                for(NSDictionary *_info in succeedResult[@"ret"]){
                    ADTOrderInfo *info = [[ADTOrderInfo alloc]init];
                    info.m_openid = [_info stringWithFilted:@"openid"];
                    info.m_time = [_info stringWithFilted:@"time"];
                    info.m_info = [_info stringWithFilted:@"info"];
                    info.m_state = [_info stringWithFilted:@"state"];
                    info.m_confirmtime = [_info stringWithFilted:@"confirmtime"];
                    info.m_owner = [_info stringWithFilted:@"owner"];
                    info.m_inserttime = [_info stringWithFilted:@"inserttime"];
                    info.m_id = [_info stringWithFilted:@"_id"];
                    [_arr addObject:info];
                }
                self.m_arrData = _arr;
                [self reloadDeals];
            }


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

