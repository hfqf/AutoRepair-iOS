//
//  AddNewCustomerViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "AddNewCustomerViewController.h"
#import "SearchViewController.h"
#import "AddRepairHistoryViewController.h"
#import "EGOImageView.h"
#import "WorkroomAddOrEditViewController.h"
@implementation AddNewCustomerViewController

- (id)initWithContacer:(ADTContacterInfo *)info
{
    if(info == nil){
        self.m_currentData = [[ADTContacterInfo alloc]init];
        self.m_currentData.m_isAddNew = YES;
    }else{
        self.m_currentData = info;
        self.m_currentData.m_isAddNew = NO;
    }
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
        {
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XFEFEFE)];
            [self.tableView setBackgroundColor:UIColorFromRGB(0XFEFEFE)];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
            //注册键盘消失通知；
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
            [self addHeaderView];
        }
    return self;
}


- (id)initWithCarcode:(NSString *)carcode
{
    self.m_carcode = carcode;
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
     {
         
         self.m_currentData = [[ADTContacterInfo alloc]init];
         self.m_currentData.m_carCode = carcode;
         self.m_currentData.m_isAddNew = YES;
         
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
        //注册键盘消失通知；
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
         [self addHeaderView];
    }
    return self;
}

- (void)addHeaderView
{
    NSString *tipContent =  @"请提醒客户及时关注并绑定公众号(汽车修理小助手),关注后会通过公众号可以:1预约保养维修，2收到维修进度,3收到保养项目到期提醒，年审到期提醒, 4查询消费记录。";
    CGSize size = [FontSizeUtil sizeOfString:tipContent withFont:[UIFont systemFontOfSize:14] withWidth:MAIN_WIDTH-20-(self.m_currentData.m_isAddNew ? 0:160)];
    
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH,(self.m_currentData.m_isAddNew ?size.height :40)+220)];
    [bg setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
    self.tableView.tableHeaderView = bg;
    
    if(head){
        [head removeFromSuperview];
        head = nil;
    }
    head = [[EGOImageView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-150)/2, 20, 150, 150)];
    [head setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:self.m_currentData.m_strHeadUrl]] withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [head setPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
    [bg addSubview:head];
    head.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadHeadBtnClicked)];
    [head addGestureRecognizer:tap];
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(head.frame)+10, MAIN_WIDTH, 20)];
    [tip setText:@"点击修改头像"];
    [tip setTextAlignment:NSTextAlignmentCenter];
    [tip setTextColor:UIColorFromRGB(0x787878)];
    [tip setFont:[UIFont systemFontOfSize:16]];
    [bg addSubview:tip];
    if(self.m_currentData.m_isAddNew){
        UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake( 10,CGRectGetMaxY(tip.frame)+10,size.width,size.height)];
        [tip2 setText:tipContent];
        tip2.numberOfLines = 0;
        [tip2 setTextAlignment:NSTextAlignmentLeft];
        [tip2 setTextColor:UIColorFromRGB(0x90685C)];
        [tip2 setFont:[UIFont systemFontOfSize:14]];
        [bg addSubview:tip2];
    }else
    {
        UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(tip.frame)+10, MAIN_WIDTH-16, 40)];
        [tip1 setText:_m_currentData.m_strIsBindWeixin.integerValue == 1 ? @"已绑定公众号":@"未绑定公众号"];
        [tip1 setTextAlignment:NSTextAlignmentCenter];
        tip1.numberOfLines = 0;
        [tip1 setTextColor:_m_currentData.m_strIsBindWeixin.integerValue == 1 ?KEY_COMMON_BLUE_CORLOR :KEY_COMMON_GRAY_CORLOR];
        [tip1 setFont:[UIFont boldSystemFontOfSize:16]];
        [bg addSubview:tip1];
    
//        UISwitch *switcher = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tip1.frame)+10, CGRectGetMinY(tip1.frame)+10, 40, 30)];
//        switcher.on= _m_currentData.m_strIsBindWeixin.integerValue == 1;
//        switcher.enabled = NO;
//        [bg addSubview:switcher];
    }

    
}

- (void)uploadHeadBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库", nil];
    [act showInView:self.view];
}


- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo =[aNotification userInfo];
    NSValue*aValue =[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[aValue CGRectValue];
    int height =keyboardRect.size.height;
    //    int width =keyboardRect.size.width;
    [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width, MAIN_HEIGHT-height-self.tableView.frame.origin.y)];
}

- (void)keyboardDidHide:(NSNotification*)aNotification

{
    [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width, MAIN_HEIGHT-self.tableView.frame.origin.y)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:!self.m_currentData.m_isAddNew ?@"客户资料(可编辑)" : @"新增客户"];
    
    [self.view addSubview:m_bg];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:self.m_currentData.m_isAddNew ?@"保存" : @"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return !self.m_currentData.m_isAddNew ? 7 : 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0 ? 10:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section==0 ?0 : 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 6 ? 4 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
    if(indexPath.section == 0)
    {
        UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
        [tip1 setBackgroundColor:[UIColor clearColor]];
        [tip1 setFont:[UIFont systemFontOfSize:14]];
        [tip1 setText:@"车主名:"];
        [cell addSubview:tip1];
        
        if(m_userNameInput == nil)
        {
            m_userNameInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        [m_userNameInput setBackgroundColor:[UIColor whiteColor]];
        [m_userNameInput setFont:[UIFont systemFontOfSize:14]];
        m_userNameInput.layer.cornerRadius = 3;
        m_userNameInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_userNameInput.layer.borderWidth = 0.5;
        m_userNameInput.delegate = self;
        m_userNameInput.font = [UIFont systemFontOfSize:14];
        m_userNameInput.returnKeyType = UIReturnKeyNext;
        [m_userNameInput setPlaceholder:@"请输入车主名"];
        [m_userNameInput setTextColor:[UIColor blackColor]];
        [m_userNameInput setText:self.m_currentData.m_userName];
        [cell addSubview:m_userNameInput];

    }else if (indexPath.section == 1)
    {
        UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip2  setBackgroundColor:[UIColor clearColor]];
        [tip2 setFont:[UIFont systemFontOfSize:14]];
        [tip2 setText:@"车牌号:"];
        [cell addSubview:tip2];
        
        if(m_carCodeInput == nil)
        {
            m_carCodeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_carCodeInput.backgroundColor = [UIColor whiteColor];
        m_carCodeInput.returnKeyType = UIReturnKeyNext;
        [m_carCodeInput setFont:[UIFont systemFontOfSize:14]];
        m_carCodeInput.delegate = self;
        m_carCodeInput.layer.cornerRadius = 3;
        m_carCodeInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_carCodeInput.layer.borderWidth = 0.5;
        m_carCodeInput.font = [UIFont systemFontOfSize:14];
        
        [m_carCodeInput setPlaceholder:@"输入车牌号码,请勿填错"];
        [m_carCodeInput setTextColor:[UIColor blackColor]];
        [m_carCodeInput setText:self.m_currentData.m_carCode];

        [cell addSubview:m_carCodeInput];

    }else if (indexPath.section == 2)
    {
        UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip3  setBackgroundColor:[UIColor clearColor]];
        [tip3 setFont:[UIFont systemFontOfSize:14]];
        [tip3 setText:@"车主号码:"];
        [cell addSubview:tip3];
        
        if(m_telInput == nil)
        {
            m_telInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_telInput.backgroundColor = [UIColor whiteColor];
        m_telInput.returnKeyType = UIReturnKeyNext;
        [m_telInput setFont:[UIFont systemFontOfSize:14]];
        m_telInput.font = [UIFont systemFontOfSize:14];
        m_telInput.layer.cornerRadius = 3;
        m_telInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_telInput.layer.borderWidth = 0.5;
        m_telInput.delegate = self;
        [m_telInput setPlaceholder:@"11位的手机号码"];
        [m_telInput setTextColor:[UIColor blackColor]];
        [m_telInput setText:self.m_currentData.m_tel];
        [cell addSubview:m_telInput];
    }else if (indexPath.section == 3)
    {
        UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip4  setBackgroundColor:[UIColor clearColor]];
        [tip4 setFont:[UIFont systemFontOfSize:14]];
        [tip4 setText:@"车型:"];
        [cell addSubview:tip4];
        
        if(m_carTypeInput == nil)
        {
            m_carTypeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_carTypeInput.backgroundColor = [UIColor whiteColor];
        [m_carTypeInput setFont:[UIFont systemFontOfSize:14]];
        m_carTypeInput.layer.cornerRadius = 3;
        m_carTypeInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_carTypeInput.layer.borderWidth = 0.5;
        m_carTypeInput.delegate = self;
        [m_carTypeInput setTextColor:[UIColor blackColor]];
        m_carTypeInput.returnKeyType = UIReturnKeyDone;
        [m_carTypeInput setText:self.m_currentData.m_carType];
        [cell addSubview:m_carTypeInput];

    }
    else if (indexPath.section == 4)
    {
        UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip4  setBackgroundColor:[UIColor clearColor]];
        [tip4 setFont:[UIFont systemFontOfSize:14]];
        [tip4 setText:@"车架号:"];
        [cell addSubview:tip4];
        
        if(m_vinTypeInput == nil)
        {
            m_vinTypeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_vinTypeInput.backgroundColor  =[UIColor whiteColor];
        [m_vinTypeInput setFont:[UIFont systemFontOfSize:14]];
        m_vinTypeInput.layer.cornerRadius = 3;
        m_vinTypeInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_vinTypeInput.layer.borderWidth = 0.5;
        m_vinTypeInput.delegate = self;
        [m_vinTypeInput setTextColor:[UIColor blackColor]];
        m_vinTypeInput.returnKeyType = UIReturnKeyDone;
        [m_vinTypeInput setText:self.m_currentData.m_strVin];
        [m_vinTypeInput setPlaceholder:@"车架号"];
        [cell addSubview:m_vinTypeInput];
        
    }else if (indexPath.section == 5)
    {
        UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 80, 40)];
        tip4.numberOfLines = 0;
        [tip4  setBackgroundColor:[UIColor clearColor]];
        [tip4 setFont:[UIFont systemFontOfSize:14]];
        [tip4 setText:@"车辆注册时间:"];
        [cell addSubview:tip4];
        
        if(m_registerTimeTypeInput == nil)
        {
            m_registerTimeTypeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_registerTimeTypeInput.backgroundColor = [UIColor whiteColor];
        [m_registerTimeTypeInput setFont:[UIFont systemFontOfSize:14]];
        m_registerTimeTypeInput.layer.cornerRadius = 3;
        m_registerTimeTypeInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_registerTimeTypeInput.layer.borderWidth = 0.5;
        m_registerTimeTypeInput.delegate = self;
        [m_registerTimeTypeInput setTextColor:[UIColor blackColor]];
        m_registerTimeTypeInput.returnKeyType = UIReturnKeyDone;
        [m_registerTimeTypeInput setText:self.m_currentData.m_strCarRegistertTime];
        [m_registerTimeTypeInput setPlaceholder:@"将用于推送年审到期时间"];
        [cell addSubview:m_registerTimeTypeInput];
        
    }else
    {
        if(indexPath.row == 0)
        {
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.layer.cornerRadius = 4;
            [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [deleteBtn setTitle:@"删除该客户" forState:UIControlStateNormal];
            [deleteBtn setFrame:CGRectMake(20,10, MAIN_WIDTH-40, 40)];
            [deleteBtn setBackgroundColor:KEY_DELETE_CORLOR];
            [cell addSubview:deleteBtn];

        }
        else if (indexPath.row == 1)
        {
            UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            historyBtn.layer.cornerRadius = 4;
            [historyBtn addTarget:self action:@selector(deleteAllRepairs) forControlEvents:UIControlEventTouchUpInside];
            historyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [historyBtn setTitle:@"删除该客户的所有维修记录" forState:UIControlStateNormal];
            [historyBtn setFrame:CGRectMake(20,10, MAIN_WIDTH-40, 40)];
            [historyBtn setBackgroundColor:KEY_DELETE_CORLOR];
            [cell addSubview:historyBtn];
        }
        else if (indexPath.row == 2)
        {
            
            UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            callBtn.layer.cornerRadius = 4;
            [callBtn addTarget:self action:@selector(seeAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            callBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [callBtn setTitle:@"查看该客户的所有维修记录" forState:UIControlStateNormal];
            [callBtn setFrame:CGRectMake(20,10, MAIN_WIDTH-40, 40)];
            [callBtn setBackgroundColor:KEY_COMMON_BLUE_CORLOR];
            [cell addSubview:callBtn];
        }
        else
        {
            
            UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            callBtn.layer.cornerRadius = 4;
            [callBtn addTarget:self action:@selector(addRepBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            callBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [callBtn setTitle:@"新增维修记录" forState:UIControlStateNormal];
            [callBtn setFrame:CGRectMake(20,10, MAIN_WIDTH-40, 40)];
            [callBtn setBackgroundColor:KEY_COMMON_BLUE_CORLOR];
            [cell addSubview:callBtn];
        }

    }
    
    return cell;
}

- (void)callBtnClicked
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.m_currentData.m_tel]]];
}


- (void)addRepBtnClicked
{
//    ADTRepairInfo *data = [[ADTRepairInfo alloc]init];
//    data.m_carCode = self.m_currentData.m_carCode;
//    data.m_isAddNewRepair = YES;
//    AddRepairHistoryViewController *vc = [[AddRepairHistoryViewController alloc]initWithInfo:data];
//    [self.navigationController pushViewController:vc animated:YES];
    
    ADTRepairInfo *rep = [ADTRepairInfo initWith:self.m_currentData];
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

- (void)seeAllBtnClicked
{
    SearchViewController *vc = [[SearchViewController alloc]initWith:self.m_currentData];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addBtnClicked
{
    if(self.m_currentData.m_carCode.length < 5)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车牌号不能小于5位" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_currentData.m_userName.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"用户名不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_currentData.m_tel.length != 11)
    {
        [PubllicMaskViewHelper showTipViewWith:@"手机号码必须是11位" inSuperView:self.view withDuration:1];
        return;
    }
    
    
    if(m_carTypeInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车型不能为为空" inSuperView:self.view withDuration:1];
        return;
    }

    self.m_currentData.m_carCode = m_carCodeInput.text.length == 0 ? @"" : m_carCodeInput.text;
    self.m_currentData.m_carCode = [self.m_currentData.m_carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.m_currentData.m_userName = m_userNameInput.text.length == 0 ? @"" : m_userNameInput.text;
    self.m_currentData.m_userName = [self.m_currentData.m_userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.m_currentData.m_tel = m_telInput.text.length == 0 ? @"" : m_telInput.text;
    self.m_currentData.m_carType = m_carTypeInput.text.length == 0 ? @"" : m_carTypeInput.text;
    self.m_currentData.m_strVin = m_vinTypeInput.text.length == 0 ? @"" : m_vinTypeInput.text;
    self.m_currentData.m_strCarRegistertTime = m_registerTimeTypeInput.text.length == 0 ? @"" : m_registerTimeTypeInput.text;
    
    [self showWaitingView];
    if(!self.m_currentData.m_isAddNew)
    {
        
        [HTTP_MANAGER updateCustomUrl:self.m_currentData
                  successedBlock:^(NSDictionary *succeedResult) {
                      
                      [self removeWaitingView];
                      if([succeedResult[@"code"]integerValue] == 1)
                      {
                        if([DB_Shared  updateCustomer:self.m_currentData])
                        {
                            [self backBtnClicked];
                        }
                      }
                      else
                      {
                          [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                      }
                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                      [self removeWaitingView];
                      [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                      
                  }];
    }
    else
    {
       
        [HTTP_MANAGER addContact:self.m_currentData
                  successedBlock:^(NSDictionary *succeedResult) {
                      [self removeWaitingView];
                    if([succeedResult[@"code"]integerValue] == 1)
                    {
                        self.m_currentData.m_idFromServer= succeedResult[@"ret"][@"_id"];
                        if([DB_Shared  insertNewCustom:self.m_currentData])
                        {
                            [self backBtnClicked];
                        }
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                    }
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
           [self removeWaitingView];
            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
            
        }];
       
    }
}

- (void)deleteBtnClicked
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除该顾客?" message:@"该操作无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 2;
    [alert show];
}

- (void)deleteAllRepairs{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除该顾客的所有维修记录?" message:@"该操作无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        if(alertView.tag == 1){
            [self showWaitingView];
            ADTRepairInfo *rep = [[ADTRepairInfo alloc]init];
            rep.m_carCode = self.m_currentData.m_carCode;
            rep.m_contactid = self.m_currentData.m_idFromServer;
            [HTTP_MANAGER delAllRepair:rep
                        successedBlock:^(NSDictionary *succeedResult) {
                            [self removeWaitingView];
                            if([succeedResult[@"code"]integerValue] == 1)
                            {

                                [PubllicMaskViewHelper showTipViewWith:@"操作成功" inSuperView:self.view  withDuration:1];

                            }else{
                                [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];

                            }
                            
                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];

                            
                        }];
        }else if(alertView.tag == 2){
            [self showWaitingView];
            [HTTP_MANAGER deleteOneContact:self.m_currentData
                            successedBlock:^(NSDictionary *succeedResult) {
                                [self removeWaitingView];
                                if([succeedResult[@"code"]integerValue] == 1)
                                {
                                    if([DB_Shared deleteCustomAndRepairHisotry:self.m_currentData.m_idFromServer with:self.m_currentData.m_carCode])
                                    {

                                        [self backBtnClicked];
                                    }
                                    else
                                    {
                                        [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                                    }
                                }
                                else
                                {
                                    [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                                }
                                
                            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                [self removeWaitingView];
                                [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                                
                            }];
        }

       
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == m_userNameInput){
        self.m_currentData.m_userName = textField.text;
    }else if (textField == m_carCodeInput){
        self.m_currentData.m_carCode = textField.text;
    }else if (textField == m_telInput){
        self.m_currentData.m_tel = textField.text;
    }else if (textField == m_carTypeInput){
        self.m_currentData.m_carType = textField.text;
    }else if (textField == m_vinTypeInput){
        self.m_currentData.m_strVin = textField.text;
    }else if (textField == m_registerTimeTypeInput){
        self.m_currentData.m_strCarRegistertTime = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == m_carCodeInput)
    {
//        [textField resignFirstResponder];
//        AddNewCarcodeSelectViewController *add = [[AddNewCarcodeSelectViewController alloc]initWith:m_carCodeInput.text];
//        add.m_selectDelegate = self;
//        [self.navigationController pushViewController:add animated:YES];
//        return NO;
        return YES;
    }else if(textField == m_registerTimeTypeInput)
    {
          UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
          UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
          [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
          [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
          [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
          [inputBg addSubview:cancelBtn];
          UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
          [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
          [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
          [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
          [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
          [inputBg addSubview:confirmBtn];
          UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH-100, 140)];
          picker.tag = 5;
          picker.datePickerMode = UIDatePickerModeDate;
          [inputBg addSubview:picker];
          textField.inputView = inputBg;
          return YES;
    }

    return YES;
}

- (void)cancelBtnClicked:(UITextField *)input
{
    [m_registerTimeTypeInput resignFirstResponder];
    m_registerTimeTypeInput.inputView = nil;
}

- (void)confirmBtnClicked:(UITextField *)input
{
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith:[picker date]];
            [m_registerTimeTypeInput setText:time];
            [m_registerTimeTypeInput resignFirstResponder];
            m_registerTimeTypeInput.inputView = nil;
            self.m_currentData.m_strCarRegistertTime = time;
            
            return;
        }
    }
}

#pragma mark - AddNewCarcodeSelectViewControllerDelegate

- (void)onInputedCarcode:(NSString *)carcode
{
    self.m_currentData.m_carCode = carcode;
    [self reloadDeals];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [LocalImageHelper selectPhotoFromCamera:self];
    }else if (buttonIndex == 1)
    {
        [LocalImageHelper selectPhotoFromLibray:self];
    }
    else
    {
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self uploadFile:image];
     });
}

- (void)uploadFile:(UIImage *)image
{
    NSString *path = [LocalImageHelper saveImage:image];
    
    NSString *fileName = [NSString stringWithFormat:@"%@",[LocalTimeUtil getCurrentTime2]];
    
    //    [self showWaitingView];
    
    [HTTP_MANAGER uploadBOSFile:path
                   withFileName: fileName
                 successedBlock:^(NSDictionary *succeedResult) {
                     
                     if([succeedResult[@"code"]integerValue] == 1)
                     {
                         NSString *newHead = succeedResult[@"url"];
                         self.m_currentData.m_strHeadUrl =newHead;
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [[EGOCache globalCache]clearCache];
                             [self addHeaderView];
                         });
                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self removeWaitingView];
                             [PubllicMaskViewHelper showTipViewWith:@"上传失败" inSuperView:self.view  withDuration:1];
                         });
                     }
                     
                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self removeWaitingView];
                         [PubllicMaskViewHelper showTipViewWith:@"上传失败" inSuperView:self.view  withDuration:1];
                     });
                     
                 }];
    
}

@end
