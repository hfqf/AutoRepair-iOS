//
//  WarehouseSettingViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/27.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseSettingViewController.h"
#import "WarehousePositionViewController.h"
#import "WarehouseAddNewViewController.h"
@interface WarehouseSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation WarehouseSettingViewController

- (id)initWith:(id<WarehousePostionDelegate>)delegate
{
    self.m_selectDelegate = delegate;

    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

-(id)init
{
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
    [title setText:self.m_selectDelegate ? @"选择库房" : @"库房设置"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

- (void)addBtnClicked
{
    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseAddNewViewController") alloc]init] animated:YES];

}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllWareHouseList:^(NSDictionary *succeedResult) {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define HIGH_CELL  50
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH_CELL;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];

    cell.textLabel.text = info[@"name"];
    cell.detailTextLabel.text = info[@"desc"];

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    if(self.m_selectDelegate){
        WarehousePositionViewController *vc = [[WarehousePositionViewController alloc]initWith:info withDelegate:self.m_selectDelegate];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        self.m_selectIndex = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看详情",@"查看库位",@"删除", nil];
        [alert show];

    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){

    }else if (buttonIndex == 1){
        NSDictionary *info = [self.m_arrData objectAtIndex:self.m_selectIndex];
        WarehouseAddNewViewController *edit =[[WarehouseAddNewViewController alloc]initWith:info];
        [self.navigationController pushViewController:edit animated:YES];

    }else if (buttonIndex == 2){
        NSDictionary *info = [self.m_arrData objectAtIndex:self.m_selectIndex];
        WarehousePositionViewController *vc = [[WarehousePositionViewController alloc]initWith:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSDictionary *info = [self.m_arrData objectAtIndex:self.m_selectIndex];
        [HTTP_MANAGER delOneWarehouseWith:info[@"_id"]
                                   successedBlock:^(NSDictionary *succeedResult) {

                                       [self requestData:YES];

                                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                   }];
    }
}
@end
