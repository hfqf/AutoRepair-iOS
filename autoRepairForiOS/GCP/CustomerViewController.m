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
#import "CustomerOrdersViewController.h"
@interface CustomerViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>
{
    UISearchBar *m_searchBar;
    UILabel *m_num;
}
@property (nonatomic,strong) NSArray *m_arrIndexTitle;
@property (nonatomic,strong) NSArray *m_arrQueryContacts;
@property (assign)BOOL m_isShowOrderBtn;

@end
@implementation CustomerViewController

- (id)initForSelectContact:(NSString *)key
{
    self.m_isAdd = YES;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"可输入手机号码,车牌号,客户名搜索用户"];
        [m_searchBar setText:key];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
    }
    return self;
}

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
        
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"可输入手机号码,车牌号,客户名搜索用户"];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
    }
    return self;
}

- (id)init
{
    self.m_isAdd = NO;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.m_arrIndexTitle = [[UILocalizedIndexedCollation currentCollation]sectionTitles];

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
        m_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
        [m_searchBar setPlaceholder:@"可输入手机号码,车牌号,客户名搜索用户"];
        [m_searchBar setDelegate:self];
        m_searchBar.showsCancelButton = YES;
        self.tableView.tableHeaderView = m_searchBar;
    }
    return self;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self requestData:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self requestData:YES];
}


- (void)forceRefresh
{
    [self requestData:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
    [self.tableView setFrame:CGRectMake(0, HEIGHT_NAVIGATION, MAIN_WIDTH, MAIN_HEIGHT-HEIGHT_NAVIGATION)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addNewContactForEasyPR:) name:KEY_AUTO_ADD_CONTACT object:nil];



    [title setText:@"客户"];
    
//    m_num = [[UILabel alloc]initWithFrame:CGRectMake(40,-5+DISTANCE_TOP, 20, 20)];
//    m_num.clipsToBounds = YES;
//    m_num.textAlignment = NSTextAlignmentCenter;
//    m_num.layer.cornerRadius = 10;
//    m_num.textColor = [UIColor whiteColor];
//    m_num.backgroundColor = [UIColor redColor];
//    m_num.font = [UIFont systemFontOfSize:10];
//    m_num.hidden = YES;
//    [navigationBG addSubview:m_num];

    
    if(!self.m_isAdd)
    {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP, 40, 44)];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
        [navigationBG addSubview:addBtn];
        [title setText:@"客户"];
    }
    else
    {
        [title setText:@"选择客户"];
    }

}

- (void)orderBtnClicked
{
    CustomerOrdersViewController *vc = [[CustomerOrdersViewController  alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addNewContactForEasyPR:(NSNotification *)noti
{
    NSString *carcode = noti.object;
    NSArray *arr = [DB_Shared quertAllCustoms:carcode];
    self.m_arrQueryContacts = arr;
    if(arr.count == 0){
        AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithCarcode:noti.object];
        vc.m_delegate = self.m_delegate;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(arr.count == 1){
        ADTContacterInfo *con = [arr firstObject];
        con.m_isAddNew = NO;
        AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:con];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIActionSheet *act = [[UIActionSheet alloc]init];
        act.delegate = self;
        act.title = @"此车牌号有多客户,请选择客户";
        for(ADTContacterInfo *_info in arr){
            [act addButtonWithTitle:_info.m_tel];
        }
        [act showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ADTContacterInfo *con = [self.m_arrQueryContacts objectAtIndex:buttonIndex];
    con.m_isAddNew = NO;
    AddNewCustomerViewController *vc = [[AddNewCustomerViewController  alloc]initWithContacer:con];
    [self.navigationController pushViewController:vc animated:YES];
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
    return 60;
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
    info.m_isAddNew = NO;
    if(self.m_isAdd)
    {
        if(self.m_selectDelegate)
        {
            [self.navigationController popViewControllerAnimated:NO];
            [self.m_selectDelegate onSelectContact:info];
        }else if(self.m_queryDelegate){
            
            NSArray *arrVcs = self.navigationController.viewControllers;
            for(UIViewController *vi in arrVcs){
                if([vi isKindOfClass:NSClassFromString(@"WorkroomListViewController")]){
                    [self.navigationController popToViewController:vi animated:YES];
                }
            }
            [self.m_queryDelegate onSelectContact1:info];
        }
        else
        {
            ADTRepairInfo *data = [[ADTRepairInfo alloc]init];
            data.m_carCode = info.m_carCode;
            data.m_isAddNewRepair = YES;
            AddRepairHistoryViewController *vc = [[AddRepairHistoryViewController alloc]initWithInfo:data];
            vc.m_delegate = self.m_delegate;
            [self.navigationController pushViewController:vc animated:YES];
        }

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
    NSArray *arr = [DB_Shared quertAllCustoms:m_searchBar.text];
    
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
                if(n_contact.m_userName.length > 0 && m_contact.m_userName.length > 0){

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
        }
        // arrTemp按拼音排序
        NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:SORT_FRIEND_NICKNAME_KEY ascending:YES];
        [arrTemp sortUsingDescriptors:@[sortDes]];
        [arrLast addObject:arrTemp];
    }
    self.m_arrData = [NSMutableArray arrayWithArray:[arrLast sortedFriendArrayByKey:SORT_FRIEND_NICKNAME_KEY]];

    [self reloadDeals];
    
    
    
    
    
    [HTTP_MANAGER queryCustomerOrders:^(NSDictionary *succeedResult) {
        NSInteger count = 0;
        if([succeedResult[@"code"]integerValue] == 1){
            for(NSDictionary *_info in succeedResult[@"ret"]){
                if([_info[@"state"]integerValue] == 0){
                    count++;
                }
            }
            m_num.hidden = count==0;
            [m_num setText:[NSString stringWithFormat:@"%ld",count]];
        }
        
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        m_num.hidden = YES;
    }];
    
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
