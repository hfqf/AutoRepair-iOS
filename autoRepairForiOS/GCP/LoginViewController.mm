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
    UIButton  *m_checkBtn;
    UILabel *m_tip;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.hidden = YES;
    navigationBG.hidden = YES;
    m_asyncCount = 0;
    
    [self.m_head setPlaceholderImage:[UIImage imageNamed:@"app_icon"]];
    self.m_head.clipsToBounds = YES;
    self.m_head.contentMode = UIViewContentModeScaleAspectFill;

        
    self.registerBtn.clipsToBounds = YES;
    self.registerBtn.layer.borderColor =  PUBLIC_BACKGROUND_COLOR.CGColor;
    self.registerBtn.layer.borderWidth = 0.5;
    [self.registerBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [self.loginBtn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
    [self.registerBtn setTitleColor:PUBLIC_BACKGROUND_COLOR forState:UIControlStateNormal];
    
    self.loginBtn.layer.cornerRadius = 5;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];
    //注册键盘消失通知；
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];
//    self.forgetPwdBtn.layer.cornerRadius = 3;
//    self.forgetPwdBtn.layer.borderColor =  PUBLIC_BACKGROUND_COLOR.CGColor;
//    self.forgetPwdBtn.layer.borderWidth = 0.5;
    
    
   


}

- (void)showVersionUpdateView:(NSDictionary *)info
{
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    
    BOOL isNeedShow = [info[@"isneedshow"]integerValue] == 1;

    if(([info[@"lastest"]integerValue] > [build integerValue]) && isNeedShow)
    {
        BOOL isForceUp = [info[@"isforceup"]integerValue] == 1;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"版本升级"
                                                       message:info[@"newfeature"]
                                                      delegate:self
                                             cancelButtonTitle:isForceUp ? nil : @"稍后升级"
                                             otherButtonTitles: @"马上升级", nil];
        
        CGSize size = [FontSizeUtil sizeOfString:alert.message withFont:[UIFont systemFontOfSize:16] withWidth:400];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20,240, size.height)];
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.lineBreakMode =NSLineBreakByWordWrapping;
        textLabel.numberOfLines =0;
        textLabel.textAlignment =NSTextAlignmentLeft;
        textLabel.text = @"";
        [alert setValue:textLabel forKey:@"accessoryView"];
        [alert show];
    }
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo =[aNotification userInfo];
    NSValue*aValue =[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect=[aValue CGRectValue];
    int height =keyboardRect.size.height;
    //    int width =keyboardRect.size.width;
    [UIView animateKeyframesWithDuration:0.3
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
        [self.view setFrame:CGRectMake(0,-height,MAIN_WIDTH, MAIN_HEIGHT)];

    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHide:(NSNotification*)aNotification
{
    [UIView animateKeyframesWithDuration:0.3
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
                                     [self.view setFrame:CGRectMake(0,0, MAIN_WIDTH, MAIN_HEIGHT)];                                     
                                 } completion:^(BOOL finished) {
                                     
                                 }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.numberOfButtons == 1)
    {
        if(buttonIndex == 0)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%B1%BD%E4%BF%AE%E5%B0%8F%E5%8A%A9%E6%89%8B/id1106728499?mt=8"]];

        }
    }
    else
    {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%B1%BD%E4%BF%AE%E5%B0%8F%E5%8A%A9%E6%89%8B/id1106728499?mt=8"]];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    m_checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(m_checkBtn && [m_checkBtn isDescendantOfView:self.view]){
        [m_checkBtn removeFromSuperview];
        m_checkBtn = nil;
    }
    m_checkBtn.selected = [LoginUserUtil isAutoLogined];
    [m_checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [m_checkBtn setFrame:CGRectMake(20, CGRectGetMinY(self.loginBtn.frame)-35, 30, 30)];
    [m_checkBtn setImage:[UIImage imageNamed:@"check_un"] forState:UIControlStateNormal];
    [m_checkBtn setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
    [self.view addSubview:m_checkBtn];
    
    if(m_tip && [m_tip isDescendantOfView:self.view]){
        [m_tip removeFromSuperview];
        m_tip = nil;
    }
    
    m_tip = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(m_checkBtn.frame)+5, CGRectGetMinY(m_checkBtn.frame)+5, 100, 20)];
    [m_tip setText:@"是否记住密码"];
    [m_tip setTextAlignment:NSTextAlignmentLeft];
    [m_tip setFont:[UIFont systemFontOfSize:14]];
    [m_tip setTextColor:KEY_COMMON_GRAY_CORLOR];
    [self.view addSubview:m_tip];
    
}

- (void)checkBtnClicked:(UIButton *)btn
{
    m_checkBtn.selected = !btn.selected;
    [[NSUserDefaults standardUserDefaults]setObject:m_checkBtn.selected?@"1":@"0" forKey:KEY_AUTO_LOGIN];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.loginBtn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
    [self.registerBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    self.registerBtn.layer.borderColor =  UIColorFromRGB(0xf5f5f5).CGColor;
    self.registerBtn.layer.cornerRadius = 3;
    
    [self.m_head setImageURL:[NSURL URLWithString:[LoginUserUtil headUrl]]];
    self.m_head.layer.borderColor =  PUBLIC_BACKGROUND_COLOR.CGColor;
    [self.versionLab setTextColor:KEY_COMMON_GRAY_CORLOR];
    [self.versionLab setText:[NSString stringWithFormat:@"汽修小助手: %@",VERSION]];
    self.nameInput.text = [LoginUserUtil loginedName];
    self.pwdInput.text = nil;
    if([LoginUserUtil isAutoLogined]){
        self.pwdInput.text = [LoginUserUtil loginedPwd];
        [self loginBtnClicked:nil];
    }
    
    
#if KEY_IS_DEV
 
#else

    [HTTP_MANAGER checkUpdateVersion:^(NSDictionary *succeedResult) {
        
        if([succeedResult[@"code"]integerValue] == 1){
            [self showVersionUpdateView:succeedResult[@"ret"]];
        }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
    }];
    
    
#endif
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
                          
                          if([succeedResult[@"code"]integerValue] == 1)
                          {
                              
                              [[NSUserDefaults standardUserDefaults]setObject:self.nameInput.text forKey:KEY_LOGINED_NAME];
                              [[NSUserDefaults standardUserDefaults]setObject:self.pwdInput.text forKey:KEY_LOGINED_PWD];
                              
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"username"] forKey:KEY_AUTO_NAME];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"tel"] forKey:KEY_AUTO_TEL];
                              [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"viplevel"] forKey:KEY_AUTO_LEVEL];
                               [[NSUserDefaults standardUserDefaults]setObject:succeedResult[@"ret"][@"devicemodifyed"] forKey:KEY_AUTO_UDID_MODIFYED];
                               [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"shopname"] forKey:KEY_AUTO_SHOP_NAME];
                              [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"headurl"] forKey:KEY_AUTO_HEAD];
                              

                              [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"_id"] forKey:KEY_AUTO_ID];

                              [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"headurl"] forKey:KEY_AUTO_HEAD];

                              [[NSUserDefaults standardUserDefaults]setObject:[succeedResult[@"ret"] stringWithFilted:@"isdirectadditem"] forKey:KEY_AUTO_ADDITEM_SET];

                              [self queryContacts];
                              
                              [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_IS_FIRST_LOGIN];
                              
                          }
                          else
                          {
                              [self removeWaitingView];
                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                          }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"登录失败" inSuperView:self.view  withDuration:1];
        
    }];
    
}



- (void)queryContacts
{
    [[SqliteDataManager sharedInstance]deleteContacts];
    [HTTP_MANAGER queryAllContacts:[LoginUserUtil userTel]
                    successedBlock:^(NSDictionary *succeedResult) {
                        [self removeWaitingView];
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
                                    newCon.m_carCode = [info stringWithFilted:@"carcode"];
                                    newCon.m_userName = info[@"name"];
                                    newCon.m_tel = info[@"tel"];
                                    newCon.m_idFromServer = info[@"_id"];
                                    newCon.m_strInsertTime = [info stringWithFilted:@"inserttime"];
                                    newCon.m_strIsBindWeixin = info[@"isbindweixin"];
                                    newCon.m_strWeixinOPneid = info[@"weixinopenid"];
                                    newCon.m_strVin = info[@"vin"];
                                    newCon.m_strCarRegistertTime = info[@"carregistertime"];
                                    newCon.m_strHeadUrl = info[@"headurl"];
                                    [[SqliteDataManager sharedInstance]insertNewCustom:newCon];
                                }
                            }
                            
                            [self.navigationController pushViewController:[[NSClassFromString(@"MainTabBarViewController") alloc]init] animated:YES];
                        }else{
                            [self removeWaitingView];
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
