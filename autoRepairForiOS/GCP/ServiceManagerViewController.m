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
#import "ServiceManagerTableViewCell.h"
@interface ServiceManagerViewController ()<UIActionSheetDelegate,ServiceManagerTableViewCellDelegate>
@property(nonatomic,copy)NSMutableDictionary *m_selectedDic;
@end

@implementation ServiceManagerViewController

- (id)initForSelectType:(NSMutableDictionary *)selectedDic
{
    self.m_selectedDic = selectedDic;
    self.m_isSelect = YES;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_isSelect ? @"选择服务" : @"服务管理"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"确认" forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    if(self.m_selectDelegate && [self.m_selectDelegate respondsToSelector:@selector(onSelectedServices:)]){
        [self.m_selectDelegate onSelectedServices:self.m_arrData];
    }
    [self backBtnClicked];
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
                NSArray *arrSub = _info[@"subtype"];

                NSMutableArray *arrTypes = [NSMutableArray array];
                for(NSDictionary *_sub in arrSub){
                    WarehouseSubTypeInfo *subInfo = [[WarehouseSubTypeInfo alloc]init];
                    subInfo.m_isForSelect = self.m_selectDelegate != nil;
                    subInfo.m_price = _sub[@"price"];
                    subInfo.m_id = _sub[@"_id"];
                    subInfo.m_name = _sub[@"name"];
                    subInfo.m_topicId = _sub[@"toptypeid"];
                    NSString *num =self.m_selectedDic[[NSString stringWithFormat:@"1_%@",subInfo.m_name]];
                    if(num.integerValue > 0){
                        subInfo.m_selectedNum = num;
                    }else{
                        subInfo.m_selectedNum = @"0";
                    }
                    [arrTypes addObject:subInfo];
                }
                info.m_arrTypes = arrTypes;
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
//    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
//    NSArray *arr = info.m_info[@"subtype"];
//
//    NSDictionary *_info = [arr objectAtIndex:indexPath.row];
//    if(self.m_isSelect){
//        [self.m_selectDelegate onSelectGoodsType:_info];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        ServiceManaagerSubTypeAddViewController *list = [[ServiceManaagerSubTypeAddViewController alloc]initWithServiceInfo:_info];
//        [self.navigationController pushViewController:list animated:YES];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    ServiceManagerTableViewCell *cell = [[ServiceManagerTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    cell.m_delegate = self;
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    WarehouseSubTypeInfo *sub = info.m_arrTypes[indexPath.row];
    cell.subType = sub;
    return cell;
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

- (void)onReload
{
    [self reloadDeals];
}
@end
