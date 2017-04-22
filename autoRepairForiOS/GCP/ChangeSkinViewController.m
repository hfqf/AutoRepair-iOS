//
//  ChangeSkinViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/18.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ChangeSkinViewController.h"
@interface ChangeSkinViewController()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation ChangeSkinViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @"0xFF4080",
                           @"0xCD00CD",
                           @"0x4EEE94",
                           @"0x4876FF",
                           @"0xFA8072",
                           @"0xFFF68F",
                           @"0x191970",
                           ];
        [self requestData:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"换肤"];
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIColor *color = UIColorFromRGB([ConverUtil getCurrentSkin:[self.m_arrData objectAtIndex:indexPath.section]]);
    [cell setBackgroundColor:color];
    if([[self.m_arrData objectAtIndex:indexPath.section] isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:KEY_CURRENT_SKIN]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setObject:[self.m_arrData objectAtIndex:indexPath.section] forKey:KEY_CURRENT_SKIN];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
