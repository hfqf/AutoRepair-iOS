//
//  AddCustomViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15/4/29.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "AddRepairHistoryViewController.h"
#import "MainTabBarViewController.h"
#import "SqliteDataManager.h"
@implementation AddRepairHistoryViewController

- (id)initWithInfo:(ADTRepairInfo *)info
{
    self.m_currentData = info;
    self.m_currentData.m_owner = [LoginUserUtil userTel];
    if(self.m_currentData.m_isAddNewRepair){
        NSMutableArray *arrItem =[NSMutableArray array];
        self.m_currentData.m_arrRepairItem = arrItem;
        self.m_currentData.m_isClose = YES;
        self.m_currentData.m_repairCircle = @"1";
    }
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
        //注册键盘消失通知；
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
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

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_currentData.m_km ? 8 : 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self high:indexPath];
}


- (NSInteger)high:(NSIndexPath *)indexPath
{
    if(indexPath.section == 4)
    {
        return 120;
    }
    
    if(indexPath.section == 3)
    {
        return 210;
    }
    
    if(indexPath.section == 2)
    {
        return 120;
    }

    return 70;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
    {
        return 1+self.m_currentData.m_arrRepairItem.count;
    }
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        
        UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10,([self high:indexPath]-20)/2, 80, 20)];
        [tip1 setBackgroundColor:[UIColor clearColor]];
        [tip1 setFont:[UIFont systemFontOfSize:14]];
        [tip1 setText:@"公里数(KM):"];
        [cell addSubview:tip1];
        
        m_kmInput = [[UITextField alloc]initWithFrame:CGRectMake(100,([self high:indexPath]-30)/2, MAIN_WIDTH-110, 30)];
        [m_kmInput setFont:[UIFont systemFontOfSize:14]];
        m_kmInput.layer.cornerRadius = 3;
        m_kmInput.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_kmInput.layer.borderWidth = 0.2;
        m_kmInput.delegate = self;
        m_kmInput.keyboardType = UIKeyboardTypeNumberPad;
        m_kmInput.returnKeyType = UIReturnKeyDone;
        [m_kmInput setPlaceholder:@"请输入总行驶里程"];
        [m_kmInput setTextColor:[UIColor blackColor]];
        [m_kmInput setText:self.m_currentData.m_km];
        [cell addSubview:m_kmInput];
        
    }
    else if (indexPath.section == 1)
    {
        UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10,([self high:indexPath]-20)/2, 80, 20)];
        [tip2  setBackgroundColor:[UIColor clearColor]];
        [tip2 setFont:[UIFont systemFontOfSize:14]];
        [tip2 setText:@"维修日期:"];
        [cell addSubview:tip2];
        m_timeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,([self high:indexPath]-30)/2, MAIN_WIDTH-110, 30)];
        [m_timeInput setFont:[UIFont systemFontOfSize:14]];
        m_timeInput.layer.cornerRadius = 3;
        m_timeInput.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_timeInput.layer.borderWidth = 0.2;
        m_timeInput.delegate = self;
        m_timeInput.returnKeyType = UIReturnKeyDone;
        m_timeInput.keyboardType = UIKeyboardTypeNumberPad;
        [m_timeInput setPlaceholder:@"请输入日期"];
        [m_timeInput setTextColor:[UIColor blackColor]];
        [m_timeInput setText:self.m_currentData.m_time];
        [cell addSubview:m_timeInput];

    }
    else if (indexPath.section == 2)
    {
        UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 80, 20)];
        [tip3  setBackgroundColor:[UIColor clearColor]];
        [tip3 setFont:[UIFont systemFontOfSize:14]];
        [tip3 setText:@"保养项目:"];
        [cell addSubview:tip3];
        m_repairTypeInput = [[UITextView alloc]initWithFrame:CGRectMake(100,10, MAIN_WIDTH-110, 100)];
        [m_repairTypeInput setFont:[UIFont systemFontOfSize:14]];
        m_repairTypeInput.layer.cornerRadius = 3;
        m_repairTypeInput.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_repairTypeInput.layer.borderWidth = 0.2;
        m_repairTypeInput.delegate = self;
        m_repairTypeInput.returnKeyType = UIReturnKeyDone;
        [m_repairTypeInput setTextColor:[UIColor blackColor]];
        [m_repairTypeInput setText:self.m_currentData.m_repairType];
        [cell addSubview:m_repairTypeInput];
    }
    else if (indexPath.section == 3)
    {
        if(indexPath.row == 0)
        {
            UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-40)/2, 80, 40)];
            tip3.numberOfLines = 0;
            [tip3  setBackgroundColor:[UIColor clearColor]];
            [tip3 setFont:[UIFont systemFontOfSize:14]];
            [tip3 setText:@"增加收费明细:"];
            [cell addSubview:tip3];
            
            m_payDesc =[[UITextField alloc]initWithFrame:CGRectMake(100,20, MAIN_WIDTH-110, 30)];
            [m_payDesc setFont:[UIFont systemFontOfSize:14]];
            m_payDesc.layer.cornerRadius = 3;
            m_payDesc.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            m_payDesc.layer.borderWidth = 0.2;
            m_payDesc.delegate = self;
            [m_payDesc setPlaceholder:@"请输入收费项目"];
            [cell addSubview:m_payDesc];
            m_payPrice =[[UITextField alloc]initWithFrame:CGRectMake(100,70, MAIN_WIDTH-110, 30)];
            [m_payPrice setFont:[UIFont systemFontOfSize:14]];
            m_payPrice.layer.cornerRadius = 3;
            m_payPrice.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            m_payPrice.layer.borderWidth = 0.2;
            m_payPrice.delegate = self;
            m_payPrice.keyboardType = UIKeyboardTypePhonePad;
            [m_payPrice setPlaceholder:@"请输入收费价格"];
            [cell addSubview:m_payPrice];
            m_payNum =[[UITextField alloc]initWithFrame:CGRectMake(100,120, MAIN_WIDTH-110, 30)];
            [m_payNum setFont:[UIFont systemFontOfSize:14]];
            m_payNum.layer.cornerRadius = 3;
            m_payNum.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            m_payNum.layer.borderWidth = 0.2;
            m_payNum.delegate = self;
            m_payNum.keyboardType = UIKeyboardTypePhonePad;
            [m_payNum setPlaceholder:@"此条收费的次数或数量"];
            [cell addSubview:m_payNum];
            
            UIButton *addItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addItemBtn setFrame:CGRectMake(100,170, MAIN_WIDTH-110, 30)];
            [addItemBtn setTitle:@"添 加" forState:UIControlStateNormal];
            [addItemBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
            [addItemBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
            addItemBtn.layer.cornerRadius = 3;
            addItemBtn.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            addItemBtn.layer.borderWidth = 0.2;
            [cell addSubview:addItemBtn];
            [addItemBtn addTarget:self action:@selector(addItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            if(self.m_currentData.m_arrRepairItem.count > 0)
            {
                UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.5)];
                [sep setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
                [cell addSubview:sep];
            }
        }
        else
        {
            ADTRepairItemInfo *iofo = [self.m_currentData.m_arrRepairItem objectAtIndex:indexPath.row-1];
            
            UILabel * tip = [[UILabel alloc]initWithFrame:CGRectMake(2,2,16,16)];
            [tip setTextAlignment:NSTextAlignmentCenter];
            [tip setFont:[UIFont boldSystemFontOfSize:14]];
            tip.layer.cornerRadius = 8;
            tip.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            tip.layer.borderWidth = 1;
            [tip setText:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [tip setTextColor:PUBLIC_BACKGROUND_COLOR];
            [cell addSubview:tip];
            
            UILabel * labTip1 = [[UILabel alloc]initWithFrame:CGRectMake(10,22,80, 20)];
            [labTip1 setFont:[UIFont systemFontOfSize:14]];
            [labTip1 setText:@"收费项目"];
            [labTip1 setTextColor:[UIColor blackColor]];
            [cell addSubview:labTip1];
            
            UILabel * lab1 =[[UILabel alloc]initWithFrame:CGRectMake(100,20, MAIN_WIDTH-110, 30)];
            [lab1 setFont:[UIFont systemFontOfSize:14]];
            lab1.layer.cornerRadius = 3;
            lab1.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            lab1.layer.borderWidth = 0.2;
            [lab1 setText:iofo.m_type];
            [cell addSubview:lab1];
            
            
            UILabel * labTip2 = [[UILabel alloc]initWithFrame:CGRectMake(10,72,80, 20)];
            [labTip2 setFont:[UIFont systemFontOfSize:14]];
            [labTip2 setText:@"收费价格"];
            [labTip2 setTextColor:[UIColor blackColor]];
            [cell addSubview:labTip2];
            UILabel * lab2 =[[UILabel alloc]initWithFrame:CGRectMake(100,70, MAIN_WIDTH-110, 30)];
            [lab2 setFont:[UIFont systemFontOfSize:14]];
            lab2.layer.cornerRadius = 3;
            lab2.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            lab2.layer.borderWidth = 0.2;
            [lab2 setText:iofo.m_price];
            [cell addSubview:lab2];
            
            
            UILabel * labTip3 = [[UILabel alloc]initWithFrame:CGRectMake(10,122,80, 20)];
            [labTip3 setFont:[UIFont systemFontOfSize:14]];
            [labTip3 setText:@"次数或数量"];
            [labTip3 setTextColor:[UIColor blackColor]];
            [cell addSubview:labTip3];
            UILabel * lab3 =[[UILabel alloc]initWithFrame:CGRectMake(100,120, MAIN_WIDTH-110, 30)];
            [lab3 setFont:[UIFont systemFontOfSize:14]];
            lab3.layer.cornerRadius = 3;
            lab3.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            lab3.layer.borderWidth = 0.2;
            [lab3 setText:iofo.m_num];
            [cell addSubview:lab3];
            
            UIButton *addItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addItemBtn.tag = indexPath.row-1;
            [addItemBtn setFrame:CGRectMake(100,170, MAIN_WIDTH-110, 30)];
            [addItemBtn setTitle:@"删 除" forState:UIControlStateNormal];
            [addItemBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
            [addItemBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
            addItemBtn.layer.cornerRadius = 3;
            addItemBtn.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
            addItemBtn.layer.borderWidth = 0.2;
            [cell addSubview:addItemBtn];
            [addItemBtn addTarget:self action:@selector(delelteItemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, [self high:indexPath]-0.5, MAIN_WIDTH, 0.4)];
            [sep setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
            [cell addSubview:sep];
            
        }
    }
    else if (indexPath.section == 4)
    {
        UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10, ([self high:indexPath]-20)/2, 80, 20)];
        [tip4  setBackgroundColor:[UIColor clearColor]];
        [tip4 setFont:[UIFont systemFontOfSize:14]];
        [tip4 setText:@"备注:"];
        [cell addSubview:tip4];
        m_moreInput = [[UITextView alloc]initWithFrame:CGRectMake(100,([self high:indexPath]-80)/2, MAIN_WIDTH-110, 80)];
        m_moreInput.font = [UIFont systemFontOfSize:14];
        [m_moreInput setFont:[UIFont systemFontOfSize:14]];
        m_moreInput.layer.cornerRadius = 3;
        m_moreInput.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_moreInput.layer.borderWidth = 0.2;
        m_moreInput.delegate = self;
        m_moreInput.returnKeyType = UIReturnKeyDone;
        [m_moreInput setTextColor:[UIColor blackColor]];
        [m_moreInput setText:self.m_currentData.m_more];
        [cell addSubview:m_moreInput];

    }
    else if (indexPath.section == 5)
    {
        UILabel *tip5 = [[UILabel alloc]initWithFrame:CGRectMake(10,([self high:indexPath]-20)/2, 80, 20)];
        [tip5  setBackgroundColor:[UIColor clearColor]];
        [tip5 setFont:[UIFont systemFontOfSize:14]];
        [tip5 setText:@"提醒周期:"];
        [cell addSubview:tip5];
        m_tipCircleInput = [[UITextField alloc]initWithFrame:CGRectMake(100,([self high:indexPath]-30)/2, MAIN_WIDTH-110, 30)];
        [m_tipCircleInput setFont:[UIFont systemFontOfSize:14]];
        m_tipCircleInput.layer.cornerRadius = 3;
        m_tipCircleInput.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_tipCircleInput.layer.borderWidth = 0.2;
        m_tipCircleInput.delegate = self;
        m_tipCircleInput.returnKeyType = UIReturnKeyDone;
        [m_tipCircleInput setPlaceholder:@"1~360天,任选"];
        [m_tipCircleInput setTextColor:[UIColor blackColor]];
        [cell addSubview:m_tipCircleInput];
        [m_tipCircleInput setText:self.m_currentData.m_repairCircle];
    }
    else if (indexPath.section == 6)
    {
        UILabel *tip6 = [[UILabel alloc]initWithFrame:CGRectMake(10,([self high:indexPath]-20)/2, 120, 20)];
        [tip6  setBackgroundColor:[UIColor clearColor]];
        [tip6 setFont:[UIFont systemFontOfSize:14]];
        [tip6 setText:@"是否关闭提醒:"];
        [cell addSubview:tip6];
        m_isNeedTipSwitcher = [[UISwitch alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,([self high:indexPath]-30)/2, 50, 30)];
        [m_isNeedTipSwitcher setOn:!self.m_currentData.m_isClose];
        [m_isNeedTipSwitcher addTarget:self action:@selector(switchTaped:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:m_isNeedTipSwitcher];
    }
    else
    {
        if(!self.m_currentData.m_isAddNewRepair)
        {
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.layer.cornerRadius = 4;
            [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [delBtn setFrame:CGRectMake(20, ([self high:indexPath]-40)/2, MAIN_WIDTH-40, 40)];
            [delBtn setBackgroundColor:KEY_DELETE_CORLOR];
            [delBtn setTitle:@"删除该记录" forState:UIControlStateNormal];
            [cell addSubview:delBtn];
        }
    }
    return cell;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"维修记录"];

    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if(self.m_currentData.m_isAddNewRepair)
    {
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-110, DISTANCE_TOP, 100, HEIGHT_NAVIGATION)];

    }
    else
    {
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-90, DISTANCE_TOP, 80, HEIGHT_NAVIGATION)];

    }
    [addBtn setTitle:!self.m_currentData.m_isAddNewRepair ?@"确认编辑" : @"确认添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:tap];
}


- (void)delBtnClicked
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除?" message:@"该操作无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        
        [HTTP_MANAGER delOneRepair:self.m_currentData
                    successedBlock:^(NSDictionary *succeedResult) {
           
                        if([succeedResult[@"code"] integerValue] == 1)
                        {

                            [HTTP_MANAGER deleteContactItems:self.m_currentData.m_carCode successedBlock:^(NSDictionary *succeedResult) {
                                
                                
                            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                
                                
                            }];
                            
                            
                            [self backBtnClicked];
                        }
                        else
                        {
                           [PubllicMaskViewHelper showTipViewWith:@"删除失败" inSuperView:self.view withDuration:1];
                        }
            
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            [PubllicMaskViewHelper showTipViewWith:@"删除失败" inSuperView:self.view withDuration:1];

        }];
       
    }
}




- (void)tapped
{
    [m_kmInput resignFirstResponder];
    [m_timeInput resignFirstResponder];
    [m_repairTypeInput resignFirstResponder];
    [m_moreInput resignFirstResponder];
    [m_tipCircleInput resignFirstResponder];
}



- (void)addBtnClicked
{
    [self tapped];
    
    if(self.m_currentData.m_km.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"公里数不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_currentData.m_time.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"维修日期不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_currentData.m_repairType.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"保养项目不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(self.m_currentData.m_repairCircle.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"提醒周期不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    self.m_currentData.m_more = self.m_currentData.m_more == nil ? @"" : self.m_currentData.m_more;
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df1 setLocale:locale];
    NSDate *date=[df1 dateFromString:m_timeInput.text];
    
    NSDate *dateToDay = [NSDate dateWithTimeInterval:[m_tipCircleInput.text integerValue]*24*3600 sinceDate:date];//将获得当前时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:locale];
    NSString *strDate = [df stringFromDate:dateToDay];
    self.m_currentData.m_targetDate = strDate;
    self.m_currentData.m_isClose = m_isNeedTipSwitcher.isOn;
    self.m_currentData.m_insertTime = [LocalTimeUtil getCurrentTime];
    
    [self showWaitingView];

    if(!self.m_currentData.m_isAddNewRepair)
    {
        [HTTP_MANAGER updateOneRepair:self.m_currentData
                       successedBlock:^(NSDictionary *succeedResult) {
                           
                           [self removeWaitingView];
                           if([succeedResult[@"code"]integerValue] == 1)
                           {

                                   [PubllicMaskViewHelper showTipViewWith:@"修改成功" inSuperView:self.view withDuration:1];

                                   [self performSelector:@selector(backToMainTab) withObject:nil afterDelay:1];
                           }
                           else
                           {
                               [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];

                           }
                       
                           
                           
                       } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                           [self removeWaitingView];
                           [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];
                       }];
        
        
    }
    else
    {
        
        [HTTP_MANAGER addNewRepair:self.m_currentData
                    successedBlock:^(NSDictionary *succeedResult) {
            [self removeWaitingView];
            self.m_currentData.m_idFromNode = succeedResult[@"ret"][@"_id"];
                        
            if([succeedResult[@"code"]integerValue] == 1)
            {

                    [PubllicMaskViewHelper showTipViewWith:@"添加成功" inSuperView:self.view  withDuration:1];
                    [self.m_delegate onRefreshParentData];
                    [self performSelector:@selector(backToMainTab) withObject:nil afterDelay:1];
            }
            else
            {
                [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view  withDuration:1];
            }
          
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
           [self removeWaitingView];
            [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view  withDuration:1];
            
        }];
      
    }

}


- (void)backToMainTab
{
    NSArray *arr = self.navigationController.viewControllers;
    
    for(UIViewController *vc in arr)
    {
        if([vc isKindOfClass:[MainTabBarViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self backBtnClicked];
}

- (void)switchTaped:(UISwitch *)switcher
{
    
    if(!self.m_currentData.m_isAddNewRepair)
    {
        self.m_currentData.m_isClose = switcher.isOn;
        [HTTP_MANAGER updateOneRepair:self.m_currentData
                       successedBlock:^(NSDictionary *succeedResult) {
                           

                               [PubllicMaskViewHelper showTipViewWith:@"修改成功" inSuperView:self.view withDuration:1];
                           
                       } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                           [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];
                       }];
    }
 
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == m_kmInput)
    {
        self.m_currentData.m_km = textField.text;
    }else if (textField == m_timeInput)
    {
        self.m_currentData.m_time = textField.text;
    }
    else if (textField == m_tipCircleInput)
    {
        self.m_currentData.m_repairCircle = textField.text;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == m_moreInput)
    {
        self.m_currentData.m_more = textView.text;
    }else if (textView == m_repairTypeInput)
    {
        self.m_currentData.m_repairType = textView.text;
    }
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == m_timeInput)
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
    else if (textField == m_tipCircleInput)
    {
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择提醒周期" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"1天",@"7天",@"14天",@"15天",@"21天",@"28天",@"30天",@"60天",@"90天",@"120天",@"150天",@"180天",@"360天", nil];
        [act showInView:self.view];
        return NO;
    }
    else
    {
        
    }
    return YES;
}


- (void)cancelBtnClicked:(UITextField *)input
{
    [m_timeInput resignFirstResponder];
    m_timeInput.inputView = nil;
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
            [m_timeInput setText:time];
            [m_timeInput resignFirstResponder];
            m_timeInput.inputView = nil;
            return;
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)//1
    {
        [m_tipCircleInput setText:@"1"];
    }
    else if (buttonIndex == 1)//7
    {
        [m_tipCircleInput setText:@"7"];
    }
    else if (buttonIndex == 2)//14
    {
        [m_tipCircleInput setText:@"14"];
    }
    else if (buttonIndex == 3)//15
    {
        [m_tipCircleInput setText:@"15"];
    }
    else if (buttonIndex == 4)//21
    {
        [m_tipCircleInput setText:@"21"];
    }
    else if (buttonIndex == 5)//28
    {
       [m_tipCircleInput setText:@"28"];
    }
    else if (buttonIndex == 6)//30
    {
        [m_tipCircleInput setText:@"30"];
    }
    else if (buttonIndex == 7)//60
    {
        [m_tipCircleInput setText:@"60"];
    }
    else if (buttonIndex ==8)//90
    {
       [m_tipCircleInput setText:@"90"];
    }
    else if(buttonIndex == 9)//120
    {
        [m_tipCircleInput setText:@"120"];
    }
    else if(buttonIndex == 10)//150
    {
        [m_tipCircleInput setText:@"150"];
    }
    else if(buttonIndex == 11)//180
    {
        [m_tipCircleInput setText:@"180"];
    }
    else if(buttonIndex == 12)//360
    {
        [m_tipCircleInput setText:@"360"];
    }
    else
    {
        
    }
    self.m_currentData.m_repairCircle = m_tipCircleInput.text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)addItemBtnClicked
{
    if(m_payDesc.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"收费项目不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_payPrice.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"收费价格不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_payNum.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"收费次数或数量不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    [self showWaitingView];
    ADTRepairItemInfo *item = [[ADTRepairItemInfo alloc]init];
    item.m_repid = self.m_currentData.m_idFromNode;
    item.m_contactid = self.m_currentData.m_carCode;
    item.m_price = m_payPrice.text;
    item.m_num = m_payNum.text;
    item.m_type = m_payDesc.text;
    [m_payNum resignFirstResponder];
    [HTTP_MANAGER addRepairItem:item
                 successedBlock:^(NSDictionary *succeedResult) {
                     [self removeWaitingView];
                     if([succeedResult[@"code"]integerValue] == 1){
                         NSMutableArray *arr =[NSMutableArray arrayWithArray:self.m_currentData.m_arrRepairItem];
                         item.m_id = succeedResult[@"ret"][@"_id"];
                         [arr addObject:item];
                         self.m_currentData.m_arrRepairItem = arr;
                         [self reloadDeals];
                         
                         if(!self.m_currentData.m_isAddNewRepair)
                         {
                             [self addBtnClicked];
                         }
                         
                     }else{
                         [self removeWaitingView];
                         [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
                     }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view withDuration:1];
    }];
}

- (void)delelteItemBtnClicked:(UIButton *)btn
{
    ADTRepairItemInfo *item = [self.m_currentData.m_arrRepairItem objectAtIndex:btn.tag];
    [self showWaitingView];
    [HTTP_MANAGER deleteRepairItem:item
                    successedBlock:^(NSDictionary *succeedResult) {
                        [self removeWaitingView];
                        if([succeedResult[@"code"]integerValue] == 1){
                            [self.m_currentData.m_arrRepairItem removeObjectAtIndex:btn.tag];
                            [self reloadDeals];
                        }else{
                            [self removeWaitingView];
                            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
                        }
                        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view withDuration:1];
    }];
    
}
@end
