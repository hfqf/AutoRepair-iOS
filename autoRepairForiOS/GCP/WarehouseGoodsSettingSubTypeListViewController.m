//
//  WarehouseGoodsSettingSubTypeListViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/3.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsSettingSubTypeListViewController.h"
#import "WarehouseGoodsSettingSubTypeAddViewController.h"
@interface WarehouseGoodsSettingSubTypeListViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>
@property(assign)NSInteger m_selectIndex;
@end

@implementation WarehouseGoodsSettingSubTypeListViewController

-(id)initWith:(NSDictionary *)info
{
    self.m_parentInfo = info;
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
    [title setText:self.m_parentInfo[@"name"]];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
//    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
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
    WarehouseGoodsSettingSubTypeAddViewController *add = [[WarehouseGoodsSettingSubTypeAddViewController alloc]initWith:self.m_parentInfo];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllGoodsSubTypeList:self.m_parentInfo[@"_id"]
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
    self.m_selectIndex = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑",@"删除", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *info = [self.m_arrData objectAtIndex:self.m_selectIndex];
    if(buttonIndex == 0){

    }else if (buttonIndex == 1){
        WarehouseGoodsSettingSubTypeAddViewController *sub = [[WarehouseGoodsSettingSubTypeAddViewController alloc]initWithForEdit:info];
        [self.navigationController pushViewController:sub animated:YES];
    }else if (buttonIndex == 2){
        [HTTP_MANAGER delOneGoodsSubTypeWith:info[@"_id"]
                              successedBlock:^(NSDictionary *succeedResult) {
                                  [self requestData:YES];
                              } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                              }];
    }
}



@end
