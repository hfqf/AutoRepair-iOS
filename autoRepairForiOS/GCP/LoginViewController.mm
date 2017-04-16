//
//  LoginViewController.m
//  AutoRepairHelper
//
//  Created by points on 16/11/20.
//  Copyright © 2016年 Poitns. All rights reserved.
//

#define MAX_PACKET_NUM   100.0

#import "LoginViewController.h"
#import "ADTContacterInfo.h"
#import "NSDictionary+ValueCheck.h"
@interface LoginViewController ()<UIAlertViewDelegate>
{
    NSInteger  m_asyncCount;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.hidden = YES;
    navigationBG.hidden = YES;
    [title setText:@"登录"];
    m_asyncCount = 0;
    
    [self.m_head setPlaceholderImage:[UIImage imageNamed:@"icon"]];
    [self.m_head setImageURL:[NSURL URLWithString:[LoginUserUtil headUrl]]];
    
    self.registerBtn.clipsToBounds = YES;
    self.registerBtn.layer.borderColor =  PUBLIC_BACKGROUND_COLOR.CGColor;
    self.registerBtn.layer.borderWidth = 0.5;
    [self.registerBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [self.loginBtn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
    [self.registerBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
    
    self.loginBtn.layer.cornerRadius = 5;

//    self.forgetPwdBtn.layer.cornerRadius = 3;
//    self.forgetPwdBtn.layer.borderColor =  PUBLIC_BACKGROUND_COLOR.CGColor;
//    self.forgetPwdBtn.layer.borderWidth = 0.5;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_IS_TIPED_NEED_LOGIN];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nameInput.text = [LoginUserUtil loginedName];
    self.pwdInput.text = [LoginUserUtil loginedPwd];
    
    NSString *key = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IS_TIPED_NEED_LOGIN];
    if(key == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"重要通知:关于新版需要注册才能登录的说明" message:@"老版本的数据在用新版登录后不会丢失,进入主页面会上传所有数据到云端,以后就可在任意客户端进行切换" delegate:self cancelButtonTitle:@"我已清楚" otherButtonTitles:nil];
        [alert show];
    }
    

}




- (NSString *)toJSONString:(id)obi{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obi
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
return jsonString;
    }else{
        return nil;
    }
}


- (void)queryContacts
{
    if([[SqliteDataManager sharedInstance]deleteContacts])
    {
        [HTTP_MANAGER queryAllContacts:[LoginUserUtil userTel]
                        successedBlock:^(NSDictionary *succeedResult) {
                            
                            if([succeedResult[@"code"]integerValue] == 1)
                            {
                                NSArray * arr = succeedResult[@"ret"];
                                if(arr.count > 0)
                                {
                                    for(NSDictionary *info in arr)
                                    {
                                        ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
                                        newCon.m_owner = info[@"owner"];
                                        newCon.m_carType = info[@"cartype"];
                                        newCon.m_carCode = info[@"carcode"];
                                        newCon.m_carCode = [newCon.m_carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
                                        newCon.m_userName = info[@"name"];
                                        newCon.m_tel = info[@"tel"];
                                        newCon.m_idFromServer = info[@"_id"];
                                        [[SqliteDataManager sharedInstance]insertNewCustom:newCon];
                                    }
                                }
                                //通知页面更新数据
                                [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_SYNCED object:nil];
                            }
                            
                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                            
                            
                            
                        }];
    }
    
//    NSArray *arr = [[SqliteDataManager sharedInstance]quertAllCustoms];
//    NSMutableArray * arrFinal = [NSMutableArray array];
//
//    if(arr.count > 0)
//    {
//        for(ADTContacterInfo *info in arr)
//        {
//            NSDictionary *dic = @{
//                                  @"carcode" : info.m_carCode,
//                                  @"name" : info.m_userName,
//                                  @"tel" : info.m_tel,
//                                  @"cartype" : info.m_carType,
//                                  @"owner":[LoginUserUtil userTel],
//                                  @"id":info.m_idFromServer
//                                  } ;
//            [arrFinal addObject:dic];
//        }
//
//
//        long  uploadNum = ceil(arrFinal.count*1.0/MAX_PACKET_NUM);
//        __block long uploadCompleted = 0;
//
//        for(int i = 0;i<uploadNum;i++)
//        {
//            NSArray *arr = nil;
//            if(i == uploadNum-1)
//            {
//                arr =  [arrFinal subarrayWithRange:NSMakeRange(MAX_PACKET_NUM*i, arrFinal.count-MAX_PACKET_NUM*i)];
//            }
//            else
//            {
//                arr =  [arrFinal subarrayWithRange:NSMakeRange(MAX_PACKET_NUM*i, MAX_PACKET_NUM)];
//            }
//            
//        
//        [HTTP_MANAGER uploadAllContacts:[self toJSONString:arr]
//                         successedBlock:^(NSDictionary *succeedResult) {
//                             
//                             if([succeedResult[@"code"]integerValue] == 1)
//                             {
//                                 
//                                 uploadCompleted++;
//                                 if(uploadCompleted == uploadNum)//所有数据同步完成才是数据同步结束
//                                 {
//                                     [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_IS_CONTACT_AYSNED];
//                                     
//                                     if([[SqliteDataManager sharedInstance]deleteContacts])
//                                     {
//                                         [HTTP_MANAGER queryAllContacts:[LoginUserUtil userTel]
//                                                         successedBlock:^(NSDictionary *succeedResult) {
//                                                             
//                                                             if([succeedResult[@"code"]integerValue] == 1)
//                                                             {
//                                                                 NSArray * arr = succeedResult[@"ret"];
//                                                                 if(arr.count > 0)
//                                                                 {
//                                                                     for(NSDictionary *info in arr)
//                                                                     {
//                                                                         ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
//                                                                         newCon.m_owner = info[@"owner"];
//                                                                         newCon.m_carType = info[@"cartype"];
//                                                                         newCon.m_carCode = info[@"carcode"];
//                                                                         newCon.m_carCode = [newCon.m_carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
//                                                                         newCon.m_userName = info[@"name"];
//                                                                         newCon.m_tel = info[@"tel"];
//                                                                         newCon.m_idFromServer = info[@"_id"];
//                                                                         [[SqliteDataManager sharedInstance]insertNewCustom:newCon];
//                                                                     }
//                                                                 }
//                                                                 //通知页面更新数据
//                                                                 [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_SYNCED object:nil];
//                                                             }
//                                                             
//                                                         } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
//                                                             
//                                                             
//                                                             
//                                                         }];
//                                     }
//                                 }
//                            }
//                               
//                         }
//                            failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
//                                
//                                
//                                
//                            }];
//        }
//    }
//    else
//    {
//
//            [HTTP_MANAGER queryAllContacts:[LoginUserUtil userTel]
//                            successedBlock:^(NSDictionary *succeedResult) {
//                
//                if([succeedResult[@"code"]integerValue] == 1)
//                {
//                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_IS_CONTACT_AYSNED];
//                    NSArray * arr = succeedResult[@"ret"];
//                    if(arr.count > 0)
//                    {
//                        for(NSDictionary *info in arr)
//                        {
//                            ADTContacterInfo *newCon = [[ADTContacterInfo alloc]init];
//                            newCon.m_owner = info[@"owner"];
//                            newCon.m_carType = info[@"cartype"];
//                            newCon.m_carCode = info[@"carcode"];
//                            newCon.m_carCode = [newCon.m_carCode stringByReplacingOccurrencesOfString:@" " withString:@""];
//                            newCon.m_userName = info[@"name"];
//                            newCon.m_tel = info[@"tel"];
//                            newCon.m_idFromServer = info[@"_id"];
//                            [[SqliteDataManager sharedInstance]insertNewCustom:newCon];
//                        }
//                    }
//                    
//                    //通知页面更新数据
//                    [[NSNotificationCenter defaultCenter]postNotificationName:KEY_REPAIRS_SYNCED object:nil];
//                
//                }
//            
//                            
//                
//            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
//                
//            }];
//    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnClicked:(UIButton *)sender {

    if(self.nameInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"用户名不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.pwdInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"密码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    [self showWaitingView];

    
    [HTTP_MANAGER startLoginWithName:self.nameInput.text
                             withPwd:self.pwdInput.text
                      successedBlock:^(NSDictionary *succeedResult) {
                          


                          [self removeWaitingView];
                          if([succeedResult[@"code"]integerValue] == 1)
                          {
                              
                              [[NSUserDefaults standardUserDefaults]setObject:self.nameInput.text forKey:KEY_LOGINED_NAME];
                              [[NSUserDefaults standardUserDefaults]setObject:self.pwdInput.text forKey:KEY_LOGINED_PWD];
                              
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"username"] forKey:KEY_AUTO_NAME];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"tel"] forKey:KEY_AUTO_TEL];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"viplevel"] forKey:KEY_AUTO_LEVEL];
                               [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"devicemodifyed"] forKey:KEY_AUTO_UDID_MODIFYED];
                              [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"head"] forKey:KEY_AUTO_HEAD];
                               [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"shopname"] forKey:KEY_AUTO_SHOP_NAME];
                              
                              [self chechAsync];
                              
                              [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_IS_FIRST_LOGIN];
                              
                             [self.navigationController pushViewController:[[NSClassFromString(@"MainTabBarViewController") alloc]init] animated:YES];
                              
                          }
                          else
                          {
                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                          }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"登录失败" inSuperView:self.view  withDuration:1];
        
    }];
    
}


///检查此次登录是否需要同步数据
- (void)chechAsync
{
    if([LoginUserUtil isDeviceModifyed])
    {
        [self queryContacts];
    }
//    
//    if(![LoginUserUtil isRepairAsynced] || [LoginUserUtil isDeviceModifyed])
//    {
//        [self uploadRepairs];
//    }
}


- (IBAction)registerBtnClicked:(UIButton *)sender {
    [self.navigationController pushViewController:[[NSClassFromString(@"RegisterViewController") alloc]init] animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    m_currentInputY = textField.frame.origin.y;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.pwdInput)
    {
        [self loginBtnClicked:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _nameInput && string.length > 0)
    {
        if(textField.text.length+string.length == 11)
        {
            [textField setText:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            [textField resignFirstResponder];
            [self performSelector:@selector(resignPwdInput) withObject:nil afterDelay:0.5];
            return YES;

        }
    }
    
    if(textField == self.pwdInput && string.length > 0)
    {
        if(textField.text.length+string.length == 8)
        {
            [textField setText:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            [textField resignFirstResponder];
            return YES;
        }
    }
    return YES;
}

- (void)resignPwdInput
{
    [self.pwdInput becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pwdInput resignFirstResponder];
    [self.nameInput resignFirstResponder];
}
- (IBAction)forgetBtnClicked:(UIButton *)sender {
    
    [self.navigationController pushViewController:[[NSClassFromString(@"ResetPwdViewController") alloc]init] animated:YES];

}
@end
