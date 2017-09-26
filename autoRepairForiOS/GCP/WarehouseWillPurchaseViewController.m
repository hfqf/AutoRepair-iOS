//
//  WarehouseWillPurchaseViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/18.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseWillPurchaseViewController.h"
#import "WarehouseGoodsInfoViewController.h"
#import "WarehouseGoodsInSubTypeListViewController.h"


@interface WarehouseWillPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@end

@implementation WarehouseWillPurchaseViewController

- (id)initForSelectType
{
    self.m_isSelect = YES;
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
    self.m_isSelect = NO;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"物品采购"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
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
    WareHouseGoods *good = [[WareHouseGoods alloc]init];
    good.m_isAddNew = YES;
    WarehouseGoodsInfoViewController *add = [[WarehouseGoodsInfoViewController alloc]initWith:good];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllGoodsTypePreviewList:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        if([succeedResult[@"code"]integerValue] == 1)
        {
            NSArray *arr = succeedResult[@"ret"];
            NSMutableArray *arrRet = [NSMutableArray array];
            for(NSDictionary *_info in arr){
                WarehouseTopTypeInfo *info = [[WarehouseTopTypeInfo alloc]init];
                info.m_info = _info;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sectionHeaderBtn:(UIButton *)btn
{
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:btn.tag];
    info.m_isOpen = !info.m_isOpen;
    [self reloadDeals];
}

#define HIGH_CELL  40
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH_CELL;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:section];
    NSArray *arr =  info.m_info[@"subtype"];
    return info.m_isOpen ? arr.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HIGH_CELL;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 0.5)];
    bg.backgroundColor = KEY_COMMON_LIGHT_BLUE_CORLOR;
    return bg;
}

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

    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_WIDTH-30, 10, 20, 20)];
    [arrow setImage:[UIImage imageNamed:info.m_isOpen ? @"arrow_up" : @"arrow_down"]];
    [bg addSubview:arrow];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = section;
    [btn setFrame:CGRectMake(0, 0, MAIN_WIDTH, HIGH_CELL)];
    [btn addTarget:self action:@selector(sectionHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    return bg;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = navigationBG.backgroundColor;
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *arr = info.m_info[@"subtype"];

    NSDictionary *_info = [arr objectAtIndex:indexPath.row];

    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(40,10,MAIN_WIDTH-50,20)];
    [tip1 setBackgroundColor:[UIColor clearColor]];
    [tip1 setTextAlignment:NSTextAlignmentLeft];
    [tip1 setFont:[UIFont systemFontOfSize:14]];
    [tip1 setTextColor:[UIColor blackColor]];
    [tip1 setText:[NSString stringWithFormat:@"%@",_info[@"name"]]];
    [cell addSubview:tip1];


    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarehouseTopTypeInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *arr = info.m_info[@"subtype"];

    NSDictionary *_info = [arr objectAtIndex:indexPath.row];

        WarehouseGoodsInSubTypeListViewController *list = [[WarehouseGoodsInSubTypeListViewController alloc]initWith:_info];
        [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        WareHouseGoods *good = [[WareHouseGoods alloc]init];
        good.m_isAddNew = YES;
        WarehouseGoodsInfoViewController *add = [[WarehouseGoodsInfoViewController alloc]initWith:good];
        [self.navigationController pushViewController:add animated:YES];

    }else if (buttonIndex == 1){
        [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsSettingTopTypeListViewController") alloc]init] animated:YES];
    }else{

    }
}

@end

