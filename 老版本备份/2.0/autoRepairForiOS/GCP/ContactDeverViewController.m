//
//  ContactDeverViewController.m
//  AutoRepairHelper
//
//  Created by points on 16/10/28.
//  Copyright © 2016年 Poitns. All rights reserved.
//

#import "ContactDeverViewController.h"

@interface ContactDeverViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ContactDeverViewController
- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"联系开发者"];
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.row == 0)
    {
       [cell.textLabel setText:@"qq:553633471"];
    }
    else if (indexPath.row == 1)
    {
        [cell.textLabel setText:@"电话:18251846048"];
    }
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [cell addSubview:sep];
    return cell;
}

@end
