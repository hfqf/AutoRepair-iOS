//
//  LoginViewController.m
//  AutoRepairHelper
//
//  Created by points on 16/11/20.
//  Copyright © 2016年 Poitns. All rights reserved.
//

#import "LoginViewController.h"
#import "ADTContacterInfo.h"
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
  
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_IS_TIPED_NEED_LOGIN];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *key = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_IS_TIPED_NEED_LOGIN];
    if(key == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"重要通知:关于新版需要注册才能登录的说明" message:@"老版本的数据在登录后不会丢失,进入主页面会上传所有数据到云端,以后就可在任意客户端进行切换" delegate:self cancelButtonTitle:@"我已清楚" otherButtonTitles:nil];
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
        return jsonString;
    }else{
        return nil;
    }
}


- (void)uploadContacts
{
    
    NSArray *arr = [[SqliteDataManager sharedInstance]quertAllCustoms];
    NSMutableArray * arrFinal = [NSMutableArray array];
    
    if(arr.count > 0)
    {
        for(ADTContacterInfo *info in arr)
        {
            NSDictionary *dic = @{
                                  @"carcode" : info.m_carCode,
                                  @"name" : info.m_userName,
                                  @"tel" : info.m_tel,
                                  @"cartype" : info.m_carType,
                                  @"owner":[LoginUserUtil userTel]
                                  } ;
            [arrFinal addObject:dic];
        }
        
        
        
        [HTTP_MANAGER uploadAllContacts:[self toJSONString:arrFinal]
                         successedBlock:^(NSDictionary *succeedResult) {
                             
                             if([succeedResult[@"code"]integerValue] == 1)
                             {
                                 [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_IS_CONTACT_AYSNED];
                                 
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
                                                     newCon.m_userName = info[@"name"];
                                                     newCon.m_tel = info[@"tel"];
                                                     [[SqliteDataManager sharedInstance]insertNewCustom:newCon];
                                                 }
                                             }
                                         }
                                         
                                         m_asyncCount++;
                                         if (m_asyncCount == 2) {
                                             [self.navigationController pushViewController:[[NSClassFromString(@"MainTabBarViewController") alloc]init] animated:YES];
                                         }
                                         
                                         
                                     } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                         
                                     }];
                                 }
                             }
                             
                         }
                            failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                
                                
                            }];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_IS_CONTACT_AYSNED];

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
                            newCon.m_userName = info[@"name"];
                            newCon.m_tel = info[@"tel"];
                            [[SqliteDataManager sharedInstance]insertNewCustom:newCon];
                        }
                    }
                
                }
                
                m_asyncCount++;
                if (m_asyncCount == 2) {
                    [self.navigationController pushViewController:[[NSClassFromString(@"MainTabBarViewController") alloc]init] animated:YES];
                }
                
            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                
            }];
    }
}


- (void)uploadRepairs
{
    NSArray *arrRepair = [[SqliteDataManager sharedInstance]queryAllRepairs];
    NSMutableArray * arrFinal = [NSMutableArray array];
    
    for(ADTRepairInfo *info in arrRepair)
    {
        NSDictionary *dic = @{
                              @"carcode" : info.m_carCode,
                              @"totalkm" : info.m_km,
                              @"repairetime" : info.m_time,
                              @"addition":info.m_more,
                              @"repairtype":info.m_repairType,
                              @"tipcircle":info.m_targetDate,
                              @"isclose":info.m_isClose ? @"1" : @"0",
                              @"circle":info.m_repairCircle,
                              @"isreaded":info.m_isClose ? @"1" : @"0",
                              @"owner":[LoginUserUtil userTel]
                              } ;
        [arrFinal addObject:dic];
    }
    
    
    [HTTP_MANAGER uploadAllRepairs:[self toJSONString:arrFinal]
                    successedBlock:^(NSDictionary *succeedResult) {
                        
                        if([succeedResult[@"code"]integerValue] == 1)
                        {
                            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:KEY_IS_REPAIR_AYSNED];
                            
                            
                            m_asyncCount++;
                            if (m_asyncCount == 2) {
                                [self.navigationController pushViewController:[[NSClassFromString(@"MainTabBarViewController") alloc]init] animated:YES];
                            }
                        }
                        
                    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                        
                        
                    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnClicked:(UIButton *)sender {
    
    [self showWaitingView];
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
    
    
    [HTTP_MANAGER startLoginWithName:self.nameInput.text
                             withPwd:self.pwdInput.text
                      successedBlock:^(NSDictionary *succeedResult) {
                          
                          [self removeWaitingView];
                          if([succeedResult[@"code"]integerValue] == 1)
                          {
                              [self.nameInput setText:nil];
                              [self.pwdInput setText:nil];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"username"] forKey:KEY_AUTO_NAME];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"tel"] forKey:KEY_AUTO_TEL];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"viplevel"] forKey:KEY_AUTO_LEVEL];
                               [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"devicemodifyed"] forKey:KEY_AUTO_UDID_MODIFYED];
                              
                              if(![LoginUserUtil isContactAsynced] || [LoginUserUtil isDeviceModifyed])
                              {
                                  [self uploadContacts];
                              }
                              
                          
                              if(![LoginUserUtil isRepairAsynced] || [LoginUserUtil isDeviceModifyed])
                              {
                                  [self uploadRepairs];
                              }
                         
                        
                        
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


@end
