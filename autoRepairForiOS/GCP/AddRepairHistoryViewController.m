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
    if(self = [super init])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:@"维修记录"];
     m_bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame))];
  
    
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
    [tip1 setBackgroundColor:[UIColor clearColor]];
    [tip1 setFont:[UIFont systemFontOfSize:14]];
    [tip1 setText:@"公里数:"];
    [m_bg addSubview:tip1];
    
    m_kmInput = [[UITextField alloc]initWithFrame:CGRectMake(100,20, MAIN_WIDTH-110, 30)];
    [m_kmInput setFont:[UIFont systemFontOfSize:14]];
    m_kmInput.layer.cornerRadius = 3;
    m_kmInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_kmInput.layer.borderWidth = 0.5;
    m_kmInput.delegate = self;
    m_kmInput.keyboardType = UIKeyboardTypeNumberPad;
    m_kmInput.returnKeyType = UIReturnKeyDone;
    [m_kmInput setPlaceholder:@"请输入总行驶里程"];
    [m_kmInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData.m_km)
    {
        [m_kmInput setText:self.m_currentData.m_km];
        m_isAdd = NO;
    }
    else
    {
        m_isAdd = YES;
    }
    [m_bg addSubview:m_kmInput];
    
    
    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_kmInput.frame)+20, 80, 20)];
    [tip2  setBackgroundColor:[UIColor clearColor]];
    [tip2 setFont:[UIFont systemFontOfSize:14]];
    [tip2 setText:@"维修日期:"];
    [m_bg addSubview:tip2];
    m_timeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_kmInput.frame)+20, MAIN_WIDTH-110, 30)];
    [m_timeInput setFont:[UIFont systemFontOfSize:14]];
    m_timeInput.layer.cornerRadius = 3;
    m_timeInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_timeInput.layer.borderWidth = 0.5;
    m_timeInput.delegate = self;
    m_timeInput.returnKeyType = UIReturnKeyDone;
    m_timeInput.keyboardType = UIKeyboardTypeNumberPad;
    [m_timeInput setPlaceholder:@"请输入日期"];
    [m_timeInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData.m_km)
    {
        [m_timeInput setText:self.m_currentData.m_time];
    }
    [m_bg addSubview:m_timeInput];
    
    UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_timeInput.frame)+20, 80, 20)];
    [tip3  setBackgroundColor:[UIColor clearColor]];
    [tip3 setFont:[UIFont systemFontOfSize:14]];
    [tip3 setText:@"保养项目:"];
    [m_bg addSubview:tip3];
    m_repairTypeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_timeInput.frame)+20, MAIN_WIDTH-110, 30)];
    [m_repairTypeInput setFont:[UIFont systemFontOfSize:14]];
    m_repairTypeInput.layer.cornerRadius = 3;
    m_repairTypeInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_repairTypeInput.layer.borderWidth = 0.5;
    m_repairTypeInput.delegate = self;
    [m_repairTypeInput setPlaceholder:@"请输入保养项目"];
    m_repairTypeInput.returnKeyType = UIReturnKeyDone;
    [m_repairTypeInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData.m_km)
    {
        [m_repairTypeInput setText:self.m_currentData.m_repairType];
    }
    [m_bg addSubview:m_repairTypeInput];
    

    UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_repairTypeInput.frame)+20, 80, 20)];
    [tip4  setBackgroundColor:[UIColor clearColor]];
    [tip4 setFont:[UIFont systemFontOfSize:14]];
    [tip4 setText:@"备注:"];
    [m_bg addSubview:tip4];
    m_moreInput = [[UITextView alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_repairTypeInput.frame)+20, MAIN_WIDTH-110, 80)];
    m_moreInput.font = [UIFont systemFontOfSize:14];
    [m_moreInput setFont:[UIFont systemFontOfSize:14]];
    m_moreInput.layer.cornerRadius = 3;
    m_moreInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_moreInput.layer.borderWidth = 0.5;
    m_moreInput.delegate = self;
    m_moreInput.returnKeyType = UIReturnKeyDone;
    [m_moreInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData.m_km)
    {
        [m_moreInput setText:self.m_currentData.m_more];
    }
    [m_bg addSubview:m_moreInput];
    
    
    UILabel *tip5 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_moreInput.frame)+20, 80, 20)];
    [tip5  setBackgroundColor:[UIColor clearColor]];
    [tip5 setFont:[UIFont systemFontOfSize:14]];
    [tip5 setText:@"提醒周期:"];
    [m_bg addSubview:tip5];
    m_tipCircleInput = [[UITextField alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_moreInput.frame)+20, MAIN_WIDTH-110, 30)];
    [m_tipCircleInput setFont:[UIFont systemFontOfSize:14]];
    m_tipCircleInput.layer.cornerRadius = 3;
    m_tipCircleInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_tipCircleInput.layer.borderWidth = 0.5;
    m_tipCircleInput.delegate = self;
    m_tipCircleInput.returnKeyType = UIReturnKeyDone;
    [m_tipCircleInput setPlaceholder:@"1~360天,任选"];
    [m_tipCircleInput setTextColor:[UIColor blackColor]];
    [m_bg addSubview:m_tipCircleInput];
    if(self.m_currentData.m_km)
    {
        [m_tipCircleInput setText:self.m_currentData.m_repairCircle];
    }
    
    
    UILabel *tip6 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_tipCircleInput.frame)+20, 120, 20)];
    [tip6  setBackgroundColor:[UIColor clearColor]];
    [tip6 setFont:[UIFont systemFontOfSize:14]];
    [tip6 setText:@"是否关闭提醒:"];
    [m_bg addSubview:tip6];
    m_isNeedTipSwitcher = [[UISwitch alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2,CGRectGetMaxY(m_tipCircleInput.frame)+20, 50, 30)];
    if(self.m_currentData.m_km)
    {
        [m_isNeedTipSwitcher setOn:!self.m_currentData.m_isClose];
    }
    else
    {
        [m_isNeedTipSwitcher setOn:NO];
    }
    [m_isNeedTipSwitcher addTarget:self action:@selector(switchTaped:) forControlEvents:UIControlEventValueChanged];
    [m_bg addSubview:m_isNeedTipSwitcher];
    
    
    
    if(self.m_currentData.m_km)
    {
     
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.layer.cornerRadius = 4;
        [delBtn addTarget:self action:@selector(delBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [delBtn setFrame:CGRectMake(20, CGRectGetMaxY(m_isNeedTipSwitcher.frame)+20, MAIN_WIDTH-40, 40)];
        [delBtn setBackgroundColor:KEY_DELETE_CORLOR];
        [delBtn setTitle:@"删除该记录" forState:UIControlStateNormal];
        [m_bg addSubview:delBtn];
        [m_bg setContentSize:CGSizeMake(MAIN_WIDTH, CGRectGetMaxY(delBtn.frame)+100)];
    }
    else
    {
        [m_bg setContentSize:CGSizeMake(MAIN_WIDTH, CGRectGetMaxY(m_isNeedTipSwitcher.frame)+160)];

    }
    
    
    [self.view addSubview:m_bg];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if(self.m_currentData.m_km)
    {
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-110, DISTANCE_TOP, 100, HEIGHT_NAVIGATION)];

    }
    else
    {
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-90, DISTANCE_TOP, 80, HEIGHT_NAVIGATION)];

    }
    [addBtn setTitle:self.m_currentData.m_km ?@"确认编辑" : @"确认添加" forState:UIControlStateNormal];
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
                            if([DB_Shared deleteOneRepair:self.m_currentData])
                            {
                                [self backBtnClicked];
                            }
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
    
    if(m_kmInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"公里数不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_timeInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"维修日期不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_repairTypeInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"保养项目不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_moreInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"备注不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_tipCircleInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"提醒周期不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    
    
    self.m_currentData.m_km = m_kmInput.text;
    self.m_currentData.m_time = m_timeInput.text;
    self.m_currentData.m_repairType = m_repairTypeInput.text;
    self.m_currentData.m_more = m_moreInput.text;
    
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
    self.m_currentData.m_repairCircle = m_tipCircleInput.text;
    self.m_currentData.m_isClose = m_isNeedTipSwitcher.isOn;
    self.m_currentData.m_insertTime = [LocalTimeUtil getCurrentTime];
    
    [self showWaitingView];
    
    if(!m_isAdd)
    {
       
        [HTTP_MANAGER updateOneRepair:self.m_currentData
                       successedBlock:^(NSDictionary *succeedResult) {
                           
                           [self removeWaitingView];
                           if([succeedResult[@"code"]integerValue] == 1)
                           {
                               if( [[SqliteDataManager sharedInstance]updateRepair:self.m_currentData])
                               {
                                   [PubllicMaskViewHelper showTipViewWith:@"修改成功" inSuperView:self.view withDuration:1];
                                   [self performSelector:@selector(backToMainTab) withObject:nil afterDelay:1];
                                   
                               }
                               else
                               {
                                   [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];
                               }
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
                if([DB_Shared insertRepair:self.m_currentData])
                {
                    [PubllicMaskViewHelper showTipViewWith:@"添加成功" inSuperView:self.view  withDuration:1];
                    [self performSelector:@selector(backToMainTab) withObject:nil afterDelay:1];
                }
                else
                {
                    [PubllicMaskViewHelper showTipViewWith:@"添加失败" inSuperView:self.view  withDuration:1];
                }
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
    
    if(!m_isAdd)
    {
        self.m_currentData.m_isClose = switcher.isOn;
        [HTTP_MANAGER updateOneRepair:self.m_currentData
                       successedBlock:^(NSDictionary *succeedResult) {
                           
                           if( [[SqliteDataManager sharedInstance]makeOneHistory:self.m_currentData isClosed:switcher.isOn])
                           {
                               [PubllicMaskViewHelper showTipViewWith:@"修改成功" inSuperView:self.view withDuration:1];
                           }
                           else
                           {
                               [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view withDuration:1];
                           }
                           
                           
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
