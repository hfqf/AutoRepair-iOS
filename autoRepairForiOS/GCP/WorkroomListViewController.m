//
//  WorkroomListViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/7/23.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WorkroomListViewController.h"
#import "RepairHistotyTableViewCell.h"
#import "CustomerViewController.h"
#import "WorkroomAddOrEditViewController.h"
@interface WorkroomListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomerViewControllerDelegate,CustomerViewControllerDelegate1,UIActionSheetDelegate>
{
    UIView *m_tipView;
    UITextField *m_searchTextFiled;
}

@property (nonatomic,strong) NSArray *m_arrCategory;

@property (nonatomic,strong) NSArray *m_arrBtn;

@property(nonatomic,assign)NSInteger m_currentIndex;

@property(nonatomic,assign)NSInteger m_page;

@property(nonatomic,strong) ADTContacterInfo *m_contact;
@end

@implementation WorkroomListViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:YES withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 40)];
        m_searchTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(5, 2, MAIN_WIDTH-10, 36)];
        [m_searchTextFiled setDelegate:self];
        [m_searchTextFiled setPlaceholder:@"选择客户查询,不填点击搜索或下拉刷新则是查询所有"];
        [m_searchTextFiled setFont:[UIFont systemFontOfSize:13]];
        m_searchTextFiled.layer.cornerRadius = 5;
        m_searchTextFiled.layer.borderColor = UIColorFromRGB(0xDBDBDB).CGColor;
        m_searchTextFiled.layer.borderWidth = 0.5;
        m_searchTextFiled.returnKeyType = UIReturnKeyDone;
        UIImageView *left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [left setImage:[UIImage imageNamed:@"search"]];
        m_searchTextFiled.leftViewMode=UITextFieldViewModeUnlessEditing;
        m_searchTextFiled.leftView = left;
        [bg addSubview:m_searchTextFiled];
        self.tableView.tableHeaderView = bg;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forceRefresh) name:KEY_REPAIRS_UPDATED object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.hidden = YES;
    [title setText:@"工单"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"开单" forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];

    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [setBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [setBtn setFrame:CGRectMake(0, DISTANCE_TOP,100, HEIGHT_NAVIGATION)];
    [setBtn setTitle:@"收费项目" forState:UIControlStateNormal];
    [setBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:setBtn];
    [self createButtons];
}

- (void)setBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"收费项目管理" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"仓库管理(材料设置)",@"服务管理(服务设置)", nil];
    [act showInView:self.view];
}

- (void)forceRefresh
{
    [self requestData:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)createButtons
{
    self.m_currentIndex = 0;
    self.m_arrCategory = @[@"维修中",@"已修完",@"已提车",@"已取消",@"挂帐中"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i =0 ;i<self.m_arrCategory.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setFrame:CGRectMake(i*(MAIN_WIDTH/self.m_arrCategory.count), CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH/self.m_arrCategory.count, 40)];
        [btn setTitle:[self.m_arrCategory objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:i == 0 ? KEY_COMMON_CORLOR : [UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [arr addObject:btn];
    }
    self.m_arrBtn = arr;
    m_tipView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame)+36, MAIN_WIDTH/self.m_arrCategory.count, 4)];
    [self.view addSubview:m_tipView];
    [m_tipView setBackgroundColor:KEY_COMMON_CORLOR];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(m_tipView.frame), MAIN_WIDTH,MAIN_HEIGHT-CGRectGetMaxY(m_tipView.frame)-HEIGHT_MAIN_BOTTOM)];
}

#pragma mark - private

- (void)categoryBtnClicked:(UIButton *)btn
{
    self.m_currentIndex = btn.tag;
    [self requestData:YES];
    
    for(UIButton *button in self.m_arrBtn)
    {
        if(button.tag == btn.tag)
        {
            [button setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [m_tipView setFrame:CGRectMake(self.m_currentIndex*(MAIN_WIDTH/self.m_arrCategory.count), m_tipView.frame.origin.y, m_tipView.frame.size.width, m_tipView.frame.size.height)];
    }];
}


- (void)addBtnClicked
{
    CustomerViewController *vc = [[CustomerViewController alloc]initForSelectContact:@""];
    vc.m_selectDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    self.m_isRequesting = YES;
    [m_searchTextFiled setText:self.m_contact.m_carCode];
    if(isRefresh){
        self.m_page = 0;
    }else{
        self.m_page++;
    }
    NSString *state = [NSString stringWithFormat:@"%lu",(long)self.m_currentIndex];
    [self showWaitingView];
    [HTTP_MANAGER getAllRepairsWithState: state
                                withPage:self.m_page
                                withSize:self.m_contact == nil ? 20 : 1000
                               contactid:self.m_contact.m_idFromServer
                                 carCode:self.m_contact.m_carCode
                          successedBlock:^(NSDictionary *succeedResult) {
                              [self removeWaitingView];
                              self.m_contact = nil;
                              self.m_isRequesting = NO;
                              if([succeedResult[@"code"]integerValue] == 1)
                              {
                               
                                  if(isRefresh){
                                      NSMutableArray *arr = [NSMutableArray array];
                                      for(NSDictionary *info in succeedResult[@"ret"])
                                      {
                                          NSInteger index = [succeedResult[@"ret"] indexOfObject:info]+1+self.m_page*20;
                                          ADTRepairInfo*_rep = [ADTRepairInfo from:info];
                                          _rep.m_index = [NSString stringWithFormat:@"%ld", (long)index];
                                          ADTContacterInfo *con = [DB_Shared contactWithCarCode:_rep.m_carCode withContactId:_rep.m_contactid];
                                          if(con){
                                              [arr addObject:_rep];
                                          }
                                      }
                                      self.m_arrData = arr;
                                      [self reloadDeals];
                                      

                                  }else{
                                      NSMutableArray *arr = [NSMutableArray arrayWithArray:self.m_arrData];
                                      for(NSDictionary *info in succeedResult[@"ret"])
                                      {
                                          NSInteger index = [succeedResult[@"ret"] indexOfObject:info]+1+self.m_page*20;
                                          ADTRepairInfo*_rep = [ADTRepairInfo from:info];
                                          _rep.m_index = [NSString stringWithFormat:@"%ld", (long)index];
                                          ADTContacterInfo *con = [DB_Shared contactWithCarCode:_rep.m_carCode withContactId:_rep.m_contactid];
                                          if(con){
                                              [arr addObject:_rep];
                                          }
                                      }
                                      self.m_arrData = arr;
                                      [self reloadDeals];
                                      [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
                                      
                                  }
                                  
                                  
                              }
                              [self reloadDeals];
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        self.m_isRequesting = NO;
        self.m_contact = nil;
        [self removeWaitingView];
        [self reloadDeals];
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    RepairHistotyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[RepairHistotyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    ADTRepairInfo *info = [self.m_arrData objectAtIndex:indexPath.section];
    cell.info = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADTRepairInfo *rep = [self.m_arrData objectAtIndex:indexPath.section];
    WorkroomAddOrEditViewController *add = [[WorkroomAddOrEditViewController alloc]initWith:rep];
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark - CustomerViewControllerDelegate

- (void)onSelectContact:(ADTContacterInfo *)contact
{
    ADTRepairInfo *rep = [ADTRepairInfo initWith:contact];
    [self showWaitingView];
    [HTTP_MANAGER addNewRepair4:rep
                successedBlock:^(NSDictionary *succeedResult) {
                    [self removeWaitingView];
                    rep.m_idFromNode = succeedResult[@"ret"][@"_id"];
                    rep.m_state = @"0";
                    rep.m_owner = [LoginUserUtil userTel];

                    if([succeedResult[@"code"]integerValue] == 1)
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"开单成功" inSuperView:self.view  withDuration:1];
                        WorkroomAddOrEditViewController *add = [[WorkroomAddOrEditViewController alloc]initWith:rep];
                        [self.navigationController pushViewController:add animated:YES];
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"开单失败" inSuperView:self.view  withDuration:1];
                    }
                    
                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                    [self removeWaitingView];
                    [PubllicMaskViewHelper showTipViewWith:@"开单失败" inSuperView:self.view  withDuration:1];
                    
                }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CustomerViewController *vc = [[CustomerViewController alloc]initForSelectContact:textField.text];
    vc.m_queryDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}

#pragma mark - CustomerViewControllerDelegate1
- (void)onSelectContact1:(ADTContacterInfo *)contact
{
    [m_searchTextFiled setText:contact.m_carCode];
    self.m_contact = contact;
    [self requestData:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self.navigationController pushViewController:[[NSClassFromString(@"WareHouseManagerViewController") alloc]init] animated:YES];

    }else{
        [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManagerViewController") alloc]init] animated:YES];
    }
}
@end
