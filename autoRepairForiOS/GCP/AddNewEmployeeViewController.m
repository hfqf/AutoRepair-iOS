//
//  AddNewEmployeeViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/12/1.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "AddNewEmployeeViewController.h"
#import "EGOImageView.h"
@interface AddNewEmployeeViewController ()

@end

@implementation AddNewEmployeeViewController

- (id)initWith:(ADTEmployeeInfo *)employee
{
    self.m_currentData = employee;
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


- (id)init
{
    if(self.m_currentData==nil){
        ADTEmployeeInfo *info = [[ADTEmployeeInfo alloc]init];
        info.m_isAddNew = YES;
        self.m_currentData = info;
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

- (void)addHeaderView
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH,180)];
    [bg setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
    self.tableView.tableHeaderView = bg;

    if(head){
        [head removeFromSuperview];
        head = nil;
    }
    head = [[EGOImageView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-120)/2, 10, 120, 120)];
    [head setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:self.m_currentData.m_headUrl]] withDefaultImage:[UIImage imageNamed:@"app_icon"]];
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
}

- (void)uploadHeadBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库", nil];
    act.tag = 1000;
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
    [title setText:!self.m_currentData.m_isAddNew ?@"员工信息(可编辑)" : @"新增员工"];

    [self.view addSubview:m_bg];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP, 40, 44)];
    [addBtn setTitle:self.m_currentData.m_isAddNew ?@"保存" : @"保存" forState:UIControlStateNormal];
    [addBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  4;
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
    if(indexPath.row == 0)
    {
        UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 20)];
        [tip1 setBackgroundColor:[UIColor clearColor]];
        [tip1 setFont:[UIFont systemFontOfSize:14]];
        [tip1 setText:@"员工姓名:"];
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
        [m_userNameInput setPlaceholder:@"请输入员工姓名"];
        [m_userNameInput setTextColor:[UIColor blackColor]];
        [m_userNameInput setText:self.m_currentData.m_userName];
        [cell addSubview:m_userNameInput];

    }else if (indexPath.row == 1)
    {
        UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip2  setBackgroundColor:[UIColor clearColor]];
        [tip2 setFont:[UIFont systemFontOfSize:14]];
        [tip2 setText:@"登录密码:"];
        [cell addSubview:tip2];

        if(m_pwdInput == nil)
        {
            m_pwdInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_pwdInput.backgroundColor = [UIColor whiteColor];
        m_pwdInput.returnKeyType = UIReturnKeyNext;
        [m_pwdInput setFont:[UIFont systemFontOfSize:14]];
        m_pwdInput.delegate = self;
        m_pwdInput.layer.cornerRadius = 3;
        m_pwdInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_pwdInput.layer.borderWidth = 0.5;
        m_pwdInput.font = [UIFont systemFontOfSize:14];

        [m_pwdInput setPlaceholder:@"员工密码"];
        [m_pwdInput setTextColor:[UIColor blackColor]];
        [m_pwdInput setText:self.m_currentData.m_pwd];

        [cell addSubview:m_pwdInput];

    }else if (indexPath.row == 2)
    {
        UILabel *tip3 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip3  setBackgroundColor:[UIColor clearColor]];
        [tip3 setFont:[UIFont systemFontOfSize:14]];
        [tip3 setText:@"员工号码:"];
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
    }else if (indexPath.row == 3)
    {
        UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 80, 20)];
        [tip4  setBackgroundColor:[UIColor clearColor]];
        [tip4 setFont:[UIFont systemFontOfSize:14]];
        [tip4 setText:@"选择角色:"];
        [cell addSubview:tip4];

        if(m_roleTypeInput == nil)
        {
            m_roleTypeInput = [[UITextField alloc]initWithFrame:CGRectMake(100,15, MAIN_WIDTH-120, 30)];
        }
        m_roleTypeInput.userInteractionEnabled = NO;
        m_roleTypeInput.backgroundColor = [UIColor whiteColor];
        [m_roleTypeInput setFont:[UIFont systemFontOfSize:14]];
        m_roleTypeInput.layer.cornerRadius = 3;
        m_roleTypeInput.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        m_roleTypeInput.layer.borderWidth = 0.5;
        m_roleTypeInput.delegate = self;
        [m_roleTypeInput setTextColor:[UIColor blackColor]];
        m_roleTypeInput.returnKeyType = UIReturnKeyDone;
        [m_roleTypeInput setPlaceholder:@"员工角色"];
        if(self.m_currentData.m_roleType.integerValue == 1){
            [m_roleTypeInput setText:@"技师"];
        }
        [cell addSubview:m_roleTypeInput];

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3){

        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择员工角色" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"技师", nil];
        act.tag = 1001;
        [act showInView:self.view];

    }
}


- (void)addBtnClicked
{
    [m_userNameInput resignFirstResponder];
    [m_pwdInput resignFirstResponder];
    [m_telInput resignFirstResponder];
    [m_roleTypeInput resignFirstResponder];

    if(m_userNameInput.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"用户名未填" inSuperView:self.view withDuration:1];
        return;
    }

    if(m_pwdInput.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"密码未填" inSuperView:self.view withDuration:1];
        return;
    }

    if(m_telInput.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"号码未填" inSuperView:self.view withDuration:1];
        return;
    }

    if(m_roleTypeInput.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"角色未填" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_currentData.m_isAddNew){

        [self showWaitingView];
        [HTTP_MANAGER employeeAddNew:@{
                                       @"username":safeStringWith(self.m_currentData.m_userName),
                                       @"pwd":safeStringWith(self.m_currentData.m_pwd),
                                       @"headurl":safeStringWith(self.m_currentData.m_headUrl),
                                       @"tel":safeStringWith(self.m_currentData.m_tel),
                                       @"roletype":@"1",
                                       @"creatertel":[LoginUserUtil userTel],
                                       @"creater":[LoginUserUtil userId],
                                       }
                      successedBlock:^(NSDictionary *succeedResult) {
                          [self removeWaitingView];
                          if([succeedResult[@"code"]integerValue] == 1){

                              if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onRefreshParentData)]){
                                  [self.m_delegate onRefreshParentData];
                              }
                              [self backBtnClicked];

                          }else{
                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                          }

        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
            [self removeWaitingView];


        }];
    }else{

        [HTTP_MANAGER employeeUpdate:@{
                                       @"username":safeStringWith(self.m_currentData.m_userName),
                                       @"pwd":safeStringWith(self.m_currentData.m_pwd),
                                       @"headurl":safeStringWith(self.m_currentData.m_headUrl),
                                       @"tel":safeStringWith(self.m_currentData.m_tel),
                                       @"roletype":safeStringWith(self.m_currentData.m_roleType),
                                       @"id":safeStringWith(self.m_currentData.m_id),
                                       }
                      successedBlock:^(NSDictionary *succeedResult) {
                          [self removeWaitingView];
                          if([succeedResult[@"code"]integerValue] == 1){

                              if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onRefreshParentData)]){
                                  [self.m_delegate onRefreshParentData];
                              }
                              [self backBtnClicked];

                          }else{
                              [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view  withDuration:1];
                          }

                      } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                          [self removeWaitingView];


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
    }else if (textField == m_pwdInput){
        self.m_currentData.m_pwd = textField.text;
    }else if (textField == m_telInput){
        self.m_currentData.m_tel = textField.text;
    }else if (textField == m_roleTypeInput){
        self.m_currentData.m_roleType = textField.text;
    }
    return YES;
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1000){
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
    }else if (actionSheet.tag == 1001){
        if(buttonIndex==0){

            self.m_currentData.m_roleType = @"1";
            [self reloadDeals];

        }else if (buttonIndex == 1){

        }

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
                         self.m_currentData.m_headUrl =newHead;

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
