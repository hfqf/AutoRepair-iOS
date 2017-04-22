//
//  ResetPwdViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/14.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "SMS_HYZBadgeView.h"
#import <AddressBook/AddressBook.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import <SMS_SDK/Extend/SMSSDK+ExtexdMethods.h>
#import "SMSSDKUI.h"

@interface ResetPwdViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITextField *input1;
    UITextField *input2;
    UITextField *input3;
}
@end

@implementation ResetPwdViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self reloadDeals];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"重置密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    if(indexPath.row == 0)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
        [tip setText:@"手机号码"];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:tip];
        
        if(input1 == nil)
        {
            input1 = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, MAIN_WIDTH-120, 30)];
        }
        input1.layer.cornerRadius = 5;
        input1.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
        input1.layer.borderWidth = 1;
        [input1 setPlaceholder:@"号码"];
        input1.keyboardType = UIKeyboardTypeNumberPad;
        input1.delegate = self;
        input1.returnKeyType = UIReturnKeyDone;
        [cell addSubview:input1];
        
    }
    else if (indexPath.row == 1)
    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
        [tip setText:@"新密码"];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:tip];
        
        if(input2 == nil)
        {
            input2 = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, MAIN_WIDTH-120, 30)];
        }
        input2.delegate = self;
        input2.layer.cornerRadius = 5;
        input2.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
        input2.layer.borderWidth = 1;
        input2.returnKeyType = UIReturnKeyDone;
        [input2 setPlaceholder:@"新密码"];
        [cell addSubview:input2];
    }
     else if (indexPath.row == 2)

    {
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
        [tip setText:@"确认密码"];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont systemFontOfSize:16]];
        [cell addSubview:tip];
        
        if(input3 == nil)
        {
            input3 = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, MAIN_WIDTH-120, 30)];
        }
        input3.delegate = self;
        input3.layer.cornerRadius = 5;
        input3.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
        input3.layer.borderWidth = 1;
        input3.returnKeyType = UIReturnKeyDone;
        [input3  setPlaceholder:@"再次确认"];
        [cell addSubview:input3];
    }
    else
    {
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        callBtn.layer.cornerRadius = 4;
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        callBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [callBtn setTitle:@"提交" forState:UIControlStateNormal];
        [callBtn setFrame:CGRectMake(40,10, MAIN_WIDTH-80, 40)];
        [callBtn setBackgroundColor:KEY_COMMON_CORLOR];
        [cell addSubview:callBtn];
    }
    return cell;
}


- (void)callBtnClicked
{
    if(input1.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"手机号码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(input2.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"新密码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(input2.text.length >8)
    {
        [PubllicMaskViewHelper showTipViewWith:@"新密码不能长于8位" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(input3.text.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"确认密码不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(input3.text.length >8)
    {
        [PubllicMaskViewHelper showTipViewWith:@"确认密码不能长于8位" inSuperView:self.view  withDuration:1];
        return;
    }
    
    if(![input2.text isEqualToString:input3.text])
    {
        [PubllicMaskViewHelper showTipViewWith:@"两次密码输入不一致" inSuperView:self.view  withDuration:1];
        return;
    }
    //展示获取验证码界面，SMSGetCodeMethodSMS:表示通过文本短信方式获取验证码
    [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodSMS result:^(enum SMSUIResponseState state,NSString *phoneNumber,NSString *zone, NSError *error) {
        
        if([phoneNumber isEqualToString:input1.text])
        {
            
            if(state == SMSUIResponseStateSuccess)
            {
                
                [self showWaitingView];
                
                [HTTP_MANAGER regetPwd:input1.text
                                withPwd:input2.text
                         successedBlock:^(NSDictionary *succeedResult) {
                                         [self removeWaitingView];
                                         if([succeedResult[@"code"]integerValue] == 1)
                                         {
                                             [PubllicMaskViewHelper showTipViewWith:@"修改成功" inSuperView:self.view  withDuration:2];
                                             [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:2];
                                         }
                                         else
                                         {
                                             [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:2];
                                         }
                                         
                                         
                                     } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                         
                                         [self removeWaitingView];
                                         [PubllicMaskViewHelper showTipViewWith:@"修改失败" inSuperView:self.view  withDuration:1];
                                         
                                     }];
            }
        }
        else
        {
            [PubllicMaskViewHelper showTipViewWith:@"修改密码的手机号和验证码手机号码不一致!" inSuperView:self.view  withDuration:1];
        }
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
