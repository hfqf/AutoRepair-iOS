//
//  CountOnViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/3/26.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "CountOnViewController.h"
#import "NewCountOnWebViewController.h"
#import "WarehouseItem.h"
@interface CountOnViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CountOnViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @{@"category":@"报表",
                             @"items":@[
                                     @{@"icon":@"",@"title":@"新增客户数",@"type":@"0"},
                                     @{@"icon":@"",@"title":@"新增开单数",@"type":@"1"},
                                     @{@"icon":@"",@"title":@"材料销售记录",@"type":@"2"},
//                                     @{@"icon":@"",@"title":@"服务销售记录",@"type":@"3"},
                                      @{@"icon":@"",@"title":@"工单明细",@"type":@"4"},
                                     ]},
                           @{@"category":@"财务",
                             @"items":@[
                                     @{@"icon":@"",@"title":@"收入统计",@"type":@"10"},
                                     @{@"icon":@"",@"title":@"支出统计",@"type":@"11"},
                                     @{@"icon":@"",@"title":@"挂帐统计",@"type":@"12"},
                                     ]},
                           ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"统计"];
    backBtn.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}


#define HIGH_CELL  80
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *items = info[@"items"];
    return ceil(items.count*1.0/4.0)*HIGH_CELL+40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *items = info[@"items"];

    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5,5,MAIN_WIDTH-10, 20)];
    [tip setText:info[@"category"]];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:[UIColor blackColor]];
    [tip setFont:[UIFont boldSystemFontOfSize:18]];
    [cell addSubview:tip];

    for(NSDictionary *info in items){
        NSInteger index = [items indexOfObject:info];
        NSInteger row = index/4;
        NSInteger coulmn = index%4;
        NSInteger width = MAIN_WIDTH/4;
        WarehouseItem *item = [[WarehouseItem alloc]initWith:CGRectMake(coulmn*width, row*HIGH_CELL+30, width, HIGH_CELL) withRessource:info  withNum:0];
        [cell addSubview:item];
        item.itemBlock = ^(NSInteger selectTag) {

            if(selectTag==4){

                [self.navigationController pushViewController:[[NSClassFromString(@"RepairPrintViewController") alloc]init] animated:YES];
            }else{
                NewCountOnWebViewController *query = [[NewCountOnWebViewController alloc]initWith:selectTag];
                [self.navigationController pushViewController:query animated:YES];
            }
        };
    }



    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


@end

