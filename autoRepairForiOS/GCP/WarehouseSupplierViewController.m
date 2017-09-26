//
//  WarehouseSettingViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/27.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseSupplierViewController.h"
#import "WarehouseSupplierAddNewViewController.h"
#import "WarehouseSupplierInfoViewController.h"
@interface WarehouseSupplierViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,weak)id<WarehouseSupplierViewControllerDelegate>m_selectDelegate;
@property(assign)NSInteger m_selectIndex;
@end

@implementation WarehouseSupplierViewController
- (id)initWith:(id<WarehouseSupplierViewControllerDelegate>)delegate
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
    [title setText:@"供应商管理"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-90, DISTANCE_TOP,80, HEIGHT_NAVIGATION)];
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
    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseSupplierAddNewViewController") alloc]init] animated:YES];

}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllSupplierList:^(NSDictionary *succeedResult) {
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];

    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, MAIN_WIDTH/2, 20)];
    [tip1 setBackgroundColor:[UIColor clearColor]];
    [tip1 setTextAlignment:NSTextAlignmentLeft];
    [tip1 setFont:[UIFont systemFontOfSize:15]];
    [tip1 setTextColor:[UIColor blackColor]];
    [cell addSubview:tip1];

    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(5,25, MAIN_WIDTH/2, 20)];
    [tip2 setBackgroundColor:[UIColor clearColor]];
    [tip2 setTextAlignment:NSTextAlignmentLeft];
    [tip2 setFont:[UIFont systemFontOfSize:14]];
    [tip2 setTextColor:[UIColor lightGrayColor]];
    [cell addSubview:tip2];

    UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-220,15, 190, 20)];
    [tip3 setBackgroundColor:[UIColor clearColor]];
    [tip3 setTextAlignment:NSTextAlignmentRight];
    [tip3 setFont:[UIFont systemFontOfSize:14]];
    [tip3 setTextColor:[UIColor lightGrayColor]];
    [cell addSubview:tip3];

    [tip1 setText:[info stringWithFilted:@"suppliercompanyname"]];
    [tip2 setText:[info stringWithFilted:@"managername"]];
    [tip3 setText:[info stringWithFilted:@"tel"]];

    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];
    if(self.m_selectDelegate){
        [self.m_selectDelegate onSupplierSelected:info];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.m_selectIndex = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看详情",@"删除", nil];
        [alert show];

    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){

    }else if (buttonIndex == 1){
        NSDictionary *info = [self.m_arrData objectAtIndex:self.m_selectIndex];

        WarehouseSupplierInfoViewController *vc = [[WarehouseSupplierInfoViewController alloc]initWith:info];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *info = [self.m_arrData objectAtIndex:self.m_selectIndex];

        [HTTP_MANAGER delOneWarehouseSupplierWith:info[@"_id"]
                                   successedBlock:^(NSDictionary *succeedResult) {

                                       [self requestData:YES];

        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

        }];
    }
}
@end
