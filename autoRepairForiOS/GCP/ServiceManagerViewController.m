//
//  ServiceManagerViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ServiceManagerViewController.h"
#import "ServiceManaagerSubTypeListViewController.h"
#import "ServiceManaagerSubTypeAddViewController.h"
@interface ServiceManagerViewController ()<UIActionSheetDelegate>

@end

@implementation ServiceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"服务管理"];
}


- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"新增分类", nil];
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
                info.m_isOpen = YES;
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
#define HIGH_CELL  40

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HIGH_CELL)];
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:section];
    NSArray *arr = info.m_info[@"subtype"];

    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(5,10, 120,16)];
    [tip1 setBackgroundColor:[UIColor clearColor]];
    [tip1 setTextAlignment:NSTextAlignmentLeft];
    [tip1 setFont:[UIFont systemFontOfSize:14]];
    [tip1 setTextColor:[UIColor blackColor]];
    [tip1 setText:[NSString stringWithFormat:@"%@(%lu)",info.m_info[@"name"],arr.count]];
    [bg addSubview:tip1];

//    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 10, 20, 20)];
//    [arrow setImage:[UIImage imageNamed:info.m_isOpen ? @"arrow_up" : @"arrow_down"]];
//    [bg addSubview:arrow];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = section;
    [btn setFrame:CGRectMake(0, 0, MAIN_WIDTH, HIGH_CELL)];
    [btn addTarget:self action:@selector(sectionHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    return bg;
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
        ServiceManaagerSubTypeAddViewController *list = [[ServiceManaagerSubTypeAddViewController alloc]initWithServiceInfo:_info];
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (void)sectionHeaderBtn:(UIButton *)btn
{
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:btn.tag];
    ServiceManaagerSubTypeAddViewController *add = [[ServiceManaagerSubTypeAddViewController alloc]initWith:info.m_info];
    [self.navigationController pushViewController:add animated:YES];
    
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
