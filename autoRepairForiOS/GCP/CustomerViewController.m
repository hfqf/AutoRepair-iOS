//
//  CustomerViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "CustomerViewController.h"
#import "AddNewCustomerViewController.h"
#import "CustomerTableViewCell.h"
#import "AddRepairHistoryViewController.h"
#import "NSArray+SortByFisrtChar.h"
@interface CustomerViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *m_arrIndexTitle;

@end
@implementation CustomerViewController

- (id)initForAddRepair
{
    self.m_isAdd = YES;
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

- (id)init
{
    self.m_isAdd = NO;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES];
    if (self)
    {
        self.m_arrIndexTitle = [[UILocalizedIndexedCollation currentCollation]sectionTitles];

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //登录完后的数据回来后再次刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forceRefresh) name:KEY_REPAIRS_SYNCED object:nil];
    }
    return self;
}


- (void)forceRefresh
{
    [self requestData:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if(!self.m_isAdd)
    {
        backBtn.hidden = YES;
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-60, DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navigationBG addSubview:addBtn];
        [title setText:@"客户"];
    }
    else
    {
        [title setText:@"选择客户，添加纪录"];
    }

}

- (void)addBtnClicked
{
    AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.m_arrData objectAtIndex:section];
    return  arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    CustomerTableViewCell *cell = [[CustomerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    
    NSArray *arr = [self.m_arrData objectAtIndex:indexPath.section];
    ADTContacterInfo *info = [arr objectAtIndex:indexPath.row];
    cell.infoData = info;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arr = [self.m_arrData objectAtIndex:section];
    ADTContacterInfo *contact = [arr firstObject];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 20)];
    [header setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 200, 20)];
    [tip setBackgroundColor:[UIColor clearColor]];
    [tip setText:contact.m_strFirstChar];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:UIColorFromRGB(0x999999)];
    [tip setFont:[UIFont systemFontOfSize:14]];
    header.layer.borderWidth = 0.5;
    header.layer.borderColor = UIColorFromRGB(0xEEEEEE).CGColor;
    [header addSubview:tip];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.m_arrData objectAtIndex:indexPath.section];
    ADTContacterInfo *info = [arr objectAtIndex:indexPath.row];
    
    if(self.m_isAdd)
    {
        ADTRepairInfo *data = [[ADTRepairInfo alloc]init];
        data.m_carCode = info.m_carCode;
        AddRepairHistoryViewController *vc = [[AddRepairHistoryViewController alloc]initWithInfo:data];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
 

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *arr = [self.m_arrData objectAtIndex:section];
    ADTContacterInfo *info = [arr firstObject];
    return info.m_strFirstChar;
}

- (void)requestData:(BOOL)isRefresh
{
    NSArray *arr = [DB_Shared quertAllCustoms];
    
    NSMutableArray *arrLast = [NSMutableArray array];
    for(ADTContacterInfo *m_contact in arr)
    {
        NSMutableArray *arrTemp = [NSMutableArray array];
        if(m_contact.m_isSearch)
        {
            continue;
        }
        
        //第一个先加上去
        [arrTemp addObject:m_contact];
        for(ADTContacterInfo *n_contact in arr)
        {
            if(n_contact.m_isSearch)
            {
                continue;
            }
            else
            {
                char s1 = [NSArray pinyinFirstLetter:[[n_contact.m_userName uppercaseString] characterAtIndex:0]];
                n_contact.m_strFirstChar = [NSString stringWithFormat:@"%c",s1];
                char s2 =  [NSArray pinyinFirstLetter:[[m_contact.m_userName uppercaseString] characterAtIndex:0]];
                m_contact.m_strFirstChar = [NSString stringWithFormat:@"%c",s2];
                if([n_contact.m_strFirstChar isEqualToString:m_contact.m_strFirstChar])
                {
                    if(m_contact != n_contact)
                    {
                        n_contact.m_isSearch = YES;
                        [arrTemp addObject:n_contact];
                    }
                }
            }
        }
        // arrTemp按拼音排序
        NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:SORT_FRIEND_NICKNAME_KEY ascending:YES];
        [arrTemp sortUsingDescriptors:@[sortDes]];
        [arrLast addObject:arrTemp];
    }
    self.m_arrData = [NSMutableArray arrayWithArray:[arrLast sortedFriendArrayByKey:SORT_FRIEND_NICKNAME_KEY]];

    [self reloadDeals];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.m_arrIndexTitle;
}


-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)indexTitle atIndex:(NSInteger)index
{
    
    [PubllicMaskViewHelper showTipViewWith:indexTitle inSuperView:self.view withDuration:2];
    for(NSArray*arr in self.m_arrData)
    {
        ADTContacterInfo *contacter = [arr firstObject];
        if([contacter.m_strFirstChar isEqualToString:indexTitle])
        {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.m_arrData indexOfObject:arr]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    SpeLog(@"sectionForSectionIndexTitle--->%@-----%ld",indexTitle,(long)index);
    return [self.m_arrIndexTitle indexOfObject:indexTitle];
}

@end
