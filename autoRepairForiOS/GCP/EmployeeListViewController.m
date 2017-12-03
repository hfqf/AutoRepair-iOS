//
//  EmployeeListViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/11/30.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "EmployeeListViewController.h"
#import "AddNewEmployeeViewController.h"
@interface EmployeeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EmployeeListViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"员工管理"];
    UIButton *slideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [slideBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [slideBtn setFrame:CGRectMake(MAIN_WIDTH-80,HEIGHT_STATUSBAR, 70, 44)];
    [slideBtn setTitle:@"添加" forState:UIControlStateNormal];
    [slideBtn setTitleColor:backBtn.titleLabel.textColor forState:UIControlStateNormal];
    [navigationBG addSubview:slideBtn];
}

- (void)addBtnClicked
{
    AddNewEmployeeViewController *add = [[AddNewEmployeeViewController alloc]init];
    add.m_delegate = self;
    [self.navigationController pushViewController:add animated:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER employeeQuery:[LoginUserUtil userTel]
                 successedBlock:^(NSDictionary *succeedResult) {

                     [self removeWaitingView];
                     if([succeedResult[@"code"]integerValue] == 1){
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

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.m_arrData[indexPath.row];
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];

    EGOImageView *head = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [head setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:info[@"headurl"]] ]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [cell addSubview:head];


    UILabel *roleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70,10, 120, 15)];
    [roleLabel setBackgroundColor:[UIColor clearColor]];
    [roleLabel setTextAlignment:NSTextAlignmentLeft];
    [roleLabel setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:roleLabel];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70,28, 120, 20)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:nameLabel];

    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 28, 120, 20)];
    [telLabel setBackgroundColor:[UIColor clearColor]];
    [telLabel setTextAlignment:NSTextAlignmentLeft];
    [telLabel setFont:[UIFont systemFontOfSize:13]];
    [cell addSubview:telLabel];

    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70,50, 190, 20)];
    [timeLabel setTextColor:[UIColor blackColor]];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setFont:[UIFont systemFontOfSize:11]];
    [cell addSubview:timeLabel];

    if([info[@"roletype"]integerValue]==1){
        [roleLabel setText:@"技师"];
    }

    [timeLabel setText:[NSString stringWithFormat:@"注册时间:%@",info[@"registertime"]]];
    [nameLabel setText:info[@"username"]];
    [telLabel setText:info[@"tel"]];
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:KEY_COMMON_LIGHT_BLUE_CORLOR];
    [cell addSubview:sep];
    return cell;
}

- (void)onRefreshParentData
{
    [self requestData:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSDictionary *info = self.m_arrData[indexPath.row];

        [HTTP_MANAGER employeeDel:info[@"_id"]
                   successedBlock:^(NSDictionary *succeedResult) {
                       if([succeedResult[@"code"]integerValue]==1){
                           [self requestData:YES];
                       }

        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.m_arrData[indexPath.row];
    ADTEmployeeInfo *employee = [ADTEmployeeInfo from:info];
    AddNewEmployeeViewController *_vc = [[AddNewEmployeeViewController alloc]initWith:employee];
    _vc.m_delegate = self;
    [self.navigationController pushViewController:_vc animated:YES];
}

@end
