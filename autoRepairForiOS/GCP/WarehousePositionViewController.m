//
//  WarehouseSettingViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/27.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehousePositionViewController.h"
#import "WarehousePositionAddNewViewController.h"
@interface WarehousePositionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSDictionary *m_warehouseInfo;
@property(nonatomic,weak)id<WarehousePostionDelegate> m_selectDelegate;
@end

@implementation WarehousePositionViewController

-(id)initWith:(NSDictionary *)info withDelegate:(id)delegate
{
    self.m_warehouseInfo = info;
    self.m_selectDelegate = delegate;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

-(id)initWith:(NSDictionary *)info
{
    self.m_warehouseInfo = info;
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
    [title setText:self.m_selectDelegate ? @"选择库位" : [NSString stringWithFormat:@"库位(%@)", self.m_warehouseInfo[@"name"]]];

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
    WarehousePositionAddNewViewController *add =  [[WarehousePositionAddNewViewController alloc]initWith:self.m_warehouseInfo];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllWareHousePositionList:self.m_warehouseInfo[@"_id"]
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

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.row];

    if(self.m_selectDelegate){

        if(self.m_selectDelegate && [self.m_selectDelegate respondsToSelector:@selector(onWarehousePositionSelected:)]){
            [self.m_selectDelegate onWarehousePositionSelected:info];
        }
    }else{

    }
    
}

@end
