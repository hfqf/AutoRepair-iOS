//
//  CustomerOrdersViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "CustomerOrdersViewController.h"
#import "ADTOrderInfo.h"
#import "NSDictionary+ValueCheck.m"
#import "AddNewCustomerViewController.h"
@interface CustomerOrdersViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>
@property(assign)NSInteger m_index;
@end

@implementation CustomerOrdersViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"客户预约"];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define WIDTH_LEFT  160
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}

- (NSInteger)high:(NSIndexPath *)indexPath
{
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    CGSize size = [FontSizeUtil sizeOfString:[NSString stringWithFormat:@"预约内容:%@",info.m_info] withFont:[UIFont systemFontOfSize:15] withWidth:MAIN_WIDTH-WIDTH_LEFT-20];
    return size.height+80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
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
    [lab7 setFont:[UIFont systemFontOfSize:15]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.m_index = indexPath.section;
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    if(info.m_state.integerValue == 1){
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"直接删除",@"查看该客户详情", nil];
        [act showInView:self.view];
    }else{
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设置为已读,并发微信通知给客户",@"直接删除",@"查看该客户详情", nil];
        [act showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ADTOrderInfo *info = [self.m_arrData objectAtIndex:self.m_index];
    ADTContacterInfo *con = [DB_Shared contactWithOpenId:info.m_openid];
    if(actionSheet.numberOfButtons == 3){
        if(buttonIndex == 0){
            [self delOrder];
        }else if (buttonIndex == 1){
            AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:con];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 2){
            
        }
    }else{
        if(buttonIndex == 0){
            [self updateOrder];
        }else if (buttonIndex == 1){
              [self delOrder];
        }else if (buttonIndex == 2){
            AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:con];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
