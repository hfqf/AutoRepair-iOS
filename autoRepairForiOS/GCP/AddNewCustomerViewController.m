//
//  AddNewCustomerViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "AddNewCustomerViewController.h"
#import "SearchViewController.h"
@implementation AddNewCustomerViewController

- (id)initWithContacer:(ADTContacterInfo *)info
{
    self.m_currentData = info;
    if(self = [super init])
    {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [title setText:self.m_currentData ?@"客户详情" : @"新增客户"];
    m_bg = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame))];
    
    
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
    [tip1 setBackgroundColor:[UIColor clearColor]];
    [tip1 setFont:[UIFont systemFontOfSize:14]];
    [tip1 setText:@"车主名:"];
    [m_bg addSubview:tip1];
    
    m_userNameInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-110, 30)];
    [m_userNameInput setFont:[UIFont systemFontOfSize:14]];
    m_userNameInput.layer.cornerRadius = 3;
    m_userNameInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_userNameInput.layer.borderWidth = 0.5;
    m_userNameInput.delegate = self;
    m_userNameInput.font = [UIFont systemFontOfSize:14];
    m_userNameInput.returnKeyType = UIReturnKeyNext;
    [m_userNameInput setPlaceholder:@"请输入车主名"];
    [m_userNameInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData)
    {
        [m_userNameInput setText:self.m_currentData.m_userName];
    }
    [m_bg addSubview:m_userNameInput];
    
    
    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_userNameInput.frame)+20, 80, 20)];
    [tip2  setBackgroundColor:[UIColor clearColor]];
    [tip2 setFont:[UIFont systemFontOfSize:14]];
    [tip2 setText:@"车牌号:"];
    [m_bg addSubview:tip2];
    m_carCodeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_userNameInput.frame)+15, MAIN_WIDTH-110, 30)];
    m_carCodeInput.returnKeyType = UIReturnKeyNext;
    [m_carCodeInput setFont:[UIFont systemFontOfSize:14]];
    m_carCodeInput.delegate = self;
    m_carCodeInput.layer.cornerRadius = 3;
    m_carCodeInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_carCodeInput.layer.borderWidth = 0.5;
    m_carCodeInput.font = [UIFont systemFontOfSize:14];

    [m_carCodeInput setPlaceholder:@"输入车牌号码,请勿填错"];
    [m_carCodeInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData)
    {
        //TODO 目前由于之前的字段设置,这个车牌号不能被修改，等所有版本都升级完成后，再加上这个修改
        m_carCodeInput.userInteractionEnabled = NO;
        [m_carCodeInput setText:self.m_currentData.m_carCode];
    }
    [m_bg addSubview:m_carCodeInput];
    
    UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_carCodeInput.frame)+20, 80, 20)];
    [tip3  setBackgroundColor:[UIColor clearColor]];
    [tip3 setFont:[UIFont systemFontOfSize:14]];
    [tip3 setText:@"车主号码:"];
    [m_bg addSubview:tip3];
    m_telInput = [[UITextField alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_carCodeInput.frame)+15, MAIN_WIDTH-110, 30)];
    m_telInput.returnKeyType = UIReturnKeyNext;
    [m_telInput setFont:[UIFont systemFontOfSize:14]];
    m_telInput.font = [UIFont systemFontOfSize:14];
    m_telInput.layer.cornerRadius = 3;
    m_telInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_telInput.layer.borderWidth = 0.5;
    m_telInput.delegate = self;
    [m_telInput setPlaceholder:@"11位的手机号码"];
    [m_telInput setTextColor:[UIColor blackColor]];
    if(self.m_currentData)
    {
        [m_telInput setText:self.m_currentData.m_tel];
    }
    [m_bg addSubview:m_telInput];
    
    
    UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_telInput.frame)+20, 80, 20)];
    [tip4  setBackgroundColor:[UIColor clearColor]];
    [tip4 setFont:[UIFont systemFontOfSize:14]];
    [tip4 setText:@"车型:"];
    [m_bg addSubview:tip4];
    m_carTypeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,CGRectGetMaxY(m_telInput.frame)+15, MAIN_WIDTH-110, 30)];
    [m_carTypeInput setFont:[UIFont systemFontOfSize:14]];
    m_carTypeInput.layer.cornerRadius = 3;
    m_carTypeInput.layer.borderColor = [UIColor grayColor].CGColor;
    m_carTypeInput.layer.borderWidth = 0.5;
    m_carTypeInput.delegate = self;
    [m_carTypeInput setTextColor:[UIColor blackColor]];
    m_carTypeInput.returnKeyType = UIReturnKeyDone;
    if(self.m_currentData)
    {
        [m_carTypeInput setText:self.m_currentData.m_carType];
    }
    
    if(self.m_currentData)
    {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.layer.cornerRadius = 4;
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [deleteBtn setTitle:@"删除该顾客,以及对应纪录" forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(20, CGRectGetMaxY(m_carTypeInput.frame)+20, MAIN_WIDTH-40, 40)];
        [deleteBtn setBackgroundColor:KEY_DELETE_CORLOR];
        [m_bg addSubview:deleteBtn];
        
        UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        historyBtn.layer.cornerRadius = 4;
        [historyBtn addTarget:self action:@selector(seeAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        historyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [historyBtn setTitle:@"查看该顾客的所有维修记录" forState:UIControlStateNormal];
        [historyBtn setFrame:CGRectMake(20, CGRectGetMaxY(deleteBtn.frame)+20, MAIN_WIDTH-40, 40)];
        [historyBtn setBackgroundColor:KEY_COMMON_CORLOR];
        [m_bg addSubview:historyBtn];

        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.layer.cornerRadius = 4;
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        callBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [callBtn setTitle:@"联系客户" forState:UIControlStateNormal];
        [callBtn setFrame:CGRectMake(20, CGRectGetMaxY(historyBtn.frame)+20, MAIN_WIDTH-40, 40)];
        [callBtn setBackgroundColor:KEY_COMMON_CORLOR];
        [m_bg addSubview:callBtn];
        
        [m_bg setContentSize:CGSizeMake(MAIN_WIDTH, CGRectGetMaxY(callBtn.frame)+40)];
        
    }
    else
    {
        [m_bg setContentSize:CGSizeMake(MAIN_WIDTH, CGRectGetMaxY(m_carTypeInput.frame)+40)];

    }

    [m_bg addSubview:m_carTypeInput];

    
    
    [self.view addSubview:m_bg];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-90, DISTANCE_TOP, 80, HEIGHT_NAVIGATION)];
    [addBtn setTitle:self.m_currentData ?@"确认修改" : @"确认添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];

}

- (void)callBtnClicked
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.m_currentData.m_tel]]];
}

- (void)seeAllBtnClicked
{
    SearchViewController *vc = [[SearchViewController alloc]initWith:self.m_currentData];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addBtnClicked
{
    if(m_carCodeInput.text.length < 5)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车牌号不能小于5位" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_userNameInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"用户名不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    
    if(m_telInput.text.length != 11)
    {
        [PubllicMaskViewHelper showTipViewWith:@"手机号码必须是11位" inSuperView:self.view withDuration:1];
        return;
    }
    
    
    if(m_carTypeInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"车型为空" inSuperView:self.view withDuration:1];
        return;
    }
    
 
    
    ADTContacterInfo *new = [[ADTContacterInfo alloc]init];
    new.m_carCode = m_carCodeInput.text;
    new.m_carCode = [new.m_carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    new.m_userName = m_userNameInput.text;
    new.m_userName = [new.m_userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    new.m_tel = m_telInput.text;
    new.m_carType = m_carTypeInput.text;
    new.m_idFromServer = self.m_currentData.m_idFromServer;

    
    if(self.m_currentData)
    {
        
        [HTTP_MANAGER updateContact:new
                  successedBlock:^(NSDictionary *succeedResult) {
                      if([succeedResult[@"code"]integerValue] == 1)
                      {
                        if([DB_Shared  updateCustom:@{
                                                         @"carCode":m_carCodeInput.text,
                                                         @"name":m_userNameInput.text,
                                                         @"tel":m_telInput.text,
                                                         @"carType":m_carTypeInput.text,
                                                         @"owner":[LoginUserUtil userTel],
                                                         @"id":self.m_currentData.m_idFromServer
                                                 }])
                        {
                            [self backBtnClicked];
                        }
                      }
                      else
                      {
                          [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                      }
                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                      
                      [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                      
                  }];
    }
    else
    {
       
        [HTTP_MANAGER addContact:new
                  successedBlock:^(NSDictionary *succeedResult) {
                    if([succeedResult[@"code"]integerValue] == 1)
                    {
                        
                        ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
                        newCon.m_owner = [LoginUserUtil userTel];
                        newCon.m_carType = m_carTypeInput.text;
                        newCon.m_carCode = m_carCodeInput.text;
                        newCon.m_userName = m_userNameInput.text;
                        newCon.m_tel = m_telInput.text;
                        if([DB_Shared  insertNewCustom:newCon])
                        {
                            [self backBtnClicked];
                        }
                    }
                    else
                    {
                        [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
                    }
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
           
            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];
            
        }];
       
    }
}

- (void)deleteBtnClicked
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除该顾客?" message:@"该操作无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        
    }
    else
    {
        [HTTP_MANAGER deleteOneContact:self.m_currentData
                        successedBlock:^(NSDictionary *succeedResult) {
                            
                            if([succeedResult[@"code"]integerValue] == 1)
                            {
                                if([DB_Shared deleteCustomAndRepairHisotry:self.m_currentData.m_idFromServer with:self.m_currentData.m_carCode])
                                {
                                    ADTRepairInfo *rep = [[ADTRepairInfo alloc]init];
                                    rep.m_carCode = self.m_currentData.m_carCode;
                                    [HTTP_MANAGER delAllRepair:rep
                                                successedBlock:^(NSDictionary *succeedResult) {
                                        
                                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                        
                                    }];
                                    
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
            
            [PubllicMaskViewHelper showTipViewWith:@"操作失败" inSuperView:self.view  withDuration:1];

        }];
       
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == m_carTypeInput)
    {
        [textField resignFirstResponder];
    }
    return YES;
}
@end
