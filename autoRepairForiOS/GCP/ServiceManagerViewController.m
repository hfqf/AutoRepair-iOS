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
#import "ServiceManaagerTopTypeAddViewController.h"
@interface ServiceManagerViewController ()<UIActionSheetDelegate,ServiceManagerTableViewCellDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSMutableDictionary *m_selectedDic;
@property(assign)NSInteger m_currentIndex;
@property(nonatomic,strong)NSDictionary *m_subInfo;
@property(assign)BOOL m_isAddFirst;
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
    if(self.m_isSelect){
        [addBtn addTarget:self action:@selector(addBtnClicked1) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, 44)];
        [addBtn setTitle:@"确认" forState:UIControlStateNormal];
        [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
        [navigationBG addSubview:addBtn];
    }

}

- (void)addBtnClicked
{

    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新增分类", nil];
    [act showInView:self.view];
}

- (void)addBtnClicked1
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

        if(self.m_arrData.count == 0 && self.m_selectedDic != nil){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还未添加任何服务" message:@"马上添加?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            alert.tag = 2;
            [alert show];
        }

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
    self.m_subInfo = _info;
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑",@"删除", nil ];
    alert.tag = 1;
    [alert show];
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
    self.m_currentIndex = btn.tag;
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"选择操作" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"新增服务",@"编辑",@"删除", nil ];
    alert.tag = 0;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(alertView.tag == 0){
        WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:self.m_currentIndex];


        if(buttonIndex == 0){

        }else if (buttonIndex == 1){
            ServiceManaagerSubTypeAddViewController *add = [[ServiceManaagerSubTypeAddViewController alloc]initWith:info.m_info];
            [self.navigationController pushViewController:add animated:YES];

        }else if (buttonIndex == 2){

            ServiceManaagerTopTypeAddViewController *vc = [[ServiceManaagerTopTypeAddViewController alloc]initWith:info.m_info];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 3){
            [HTTP_MANAGER delOneServiceTopTypeWith:info.m_info[@"_id"]
                                    successedBlock:^(NSDictionary *succeedResult) {
                                        if([succeedResult[@"code"]integerValue] == 1){
                                            [self requestData:YES];
                                        }

                                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                    }];
        }
    }else if(alertView.tag == 1){
        if(buttonIndex == 0){

        }else if (buttonIndex == 1){//编辑
            ServiceManaagerSubTypeAddViewController *edit = [[ServiceManaagerSubTypeAddViewController alloc]initWithServiceInfo:self.m_subInfo];
            [self.navigationController pushViewController:edit animated:YES];
        }else if (buttonIndex == 2){//删除
            [HTTP_MANAGER delOneServiceSubTypeWith:self.m_subInfo[@"_id"]
                                    successedBlock:^(NSDictionary *succeedResult) {
                                        if([succeedResult[@"code"]integerValue] == 1){
                                            [self requestData:YES];
                                        }

                                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                    }];

        }else if (buttonIndex == 3){

        }
    }else if (alertView.tag == 2){
        if(buttonIndex == 0){

        }else if (buttonIndex == 1){
            [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManagerViewController") alloc]init] animated:YES];
        }else if (buttonIndex == 2){

        }
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

- (void)onReload
{
    [self reloadDeals];
}
@end
