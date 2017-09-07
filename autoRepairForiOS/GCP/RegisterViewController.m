//
//  RegisterViewController.m
//  AutoRepairHelper
//
//  Created by points on 16/11/20.
//  Copyright © 2016年 Poitns. All rights reserved.
//

#import "RegisterViewController.h"
#import "SMS_HYZBadgeView.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import "SMSSDKUI.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"注册"];
    [self.commitBtn setBackgroundColor:KEY_COMMON_CORLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerBtnClicked:(UIButton *)sender {
    
    if(self.accountInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"用户名不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.telInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"电话号码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.pwdInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"密码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.pwdInput.text.length > 8)
    {
        [PubllicMaskViewHelper showTipViewWith:@"密码不能超过八位" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.confirmPwdInput.text.length > 8)
    {
        [PubllicMaskViewHelper showTipViewWith:@"确认密码不能超过八位" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(self.confirmPwdInput.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"确认密码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(![self.confirmPwdInput.text isEqualToString:self.pwdInput.text])
    {
        [PubllicMaskViewHelper showTipViewWith:@"两次密码输入不一致" inSuperView:self.view  withDuration:1];
        return;
    }
    //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
    [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodSMS result:^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone, NSError *error) {
        
        if([phoneNumber isEqualToString:self.telInput.text])
        {
            
            if(state == SMSUIResponseStateSuccess)
            {
                
                [self showWaitingView];
                
                
                [HTTP_MANAGER startRegisterWithName:self.accountInput.text
                                            withTel:self.telInput.text
                                            withPwd:self.pwdInput.text
                                       withShopName:self.shopaNameInput.text
                                        withAddress:self.addressInput.text
                                        withChannel:self.channelInput.text
                                     successedBlock:^(NSDictionary *succeedResult) {
                                         [self removeWaitingView];
                                         if([succeedResult[@"code"]integerValue] == 1)
                                         {
                                             [PubllicMaskViewHelper showTipViewWith:@"注册成功" inSuperView:self.view  withDuration:2];
                                             [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:2];
                                         }
                                         else
                                         {
                                             [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:2];
                                         }
                                      
                                         
                                     } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                         
                                         [self removeWaitingView];
                                         [PubllicMaskViewHelper showTipViewWith:@"注册失败" inSuperView:self.view  withDuration:1];
                                         
                                     }];
            }
        }
        else
        {
            [PubllicMaskViewHelper showTipViewWith:@"注册的手机号和验证码手机号码不一致!" inSuperView:self.view  withDuration:1];
        }

    }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    m_currentInputY = textField.frame.origin.y;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
