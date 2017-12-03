//
//  EditUserViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "EditUserViewController.h"

@interface EditUserViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *m_value1;
@property(nonatomic,strong)NSString *m_value2;
@property(nonatomic,strong)NSString *m_value3;
@end

@implementation EditUserViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                            @"用户名",@"门店名",@"门店地址",
                           ];
        self.m_value1 = [LoginUserUtil userName];
        self.m_value2 = [LoginUserUtil shopName];
        self.m_value3 = [LoginUserUtil address];
    }
    return self;
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"编辑资料"];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP, 40, 44)];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    if(self.m_value1.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"用户名不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    if(self.m_value2.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"门店名不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    if(self.m_value3.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"门店地址不能为空" inSuperView:self.view withDuration:1];
        return;
    }
    [self showWaitingView];
    [HTTP_MANAGER updateUserName:self.m_value1
                        shopName:self.m_value2
                         address:self.m_value3
                  successedBlock:^(NSDictionary *succeedResult) {
                      [self removeWaitingView];
                      if([succeedResult[@"code"]integerValue] == 1)
                      {
                          [[NSUserDefaults standardUserDefaults]setObject:self.m_value1 forKey:KEY_AUTO_NAME];
                          [[NSUserDefaults standardUserDefaults]setObject:self.m_value2 forKey:KEY_AUTO_SHOP_NAME];
                          [[NSUserDefaults standardUserDefaults]setObject:self.m_value3 forKey:KEY_AUTO_ADDRESS];
                          [self.m_delegate onRefreshParentData];
                          [self reloadDeals];
                          [PubllicMaskViewHelper showTipViewWith:@"更新成功" inSuperView:self.view withDuration:1];
                          [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:1];
                          
                      }
                      else
                      {
                          [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view withDuration:1];
                      }
                      
                      
                  } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                      [self removeWaitingView];
                      [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view withDuration:1];
                      
                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
    
    UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10,20,60, 20)];
    [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
    [_tit setFont:[UIFont systemFontOfSize:14]];
    [_tit setText:[self.m_arrData objectAtIndex:indexPath.row]];
    [cell addSubview:_tit];
    UITextField *edit = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tit.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_tit.frame)+10)-30, 40)];
    edit.tag = indexPath.row;
    [edit setFont:[UIFont systemFontOfSize:14]];
    if(indexPath.row == 0){
        [edit setText:self.m_value1];
    }else if (indexPath.row == 1){
        [edit setText:self.m_value2];
        [edit setPlaceholder:@"必填,将用于推送维系消息"];
    }else{
        [edit setText:self.m_value3];
        [edit setPlaceholder:@"必填,将用于推送维系消息"];
    }
    edit.delegate = self;
    edit.textAlignment = NSTextAlignmentLeft;
    edit.returnKeyType = UIReturnKeyDone;
    [cell addSubview:edit];
    edit.layer.cornerRadius = 2;
    edit.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
    edit.layer.borderWidth = 0.5;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 0)
    {
        self.m_value1 = textField.text;
    }else if (textField.tag == 1)
    {
        self.m_value2 = textField.text;
    }else{
        self.m_value3 = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        self.m_value1 = textField.text;
    }else if (textField.tag == 1)
    {
        self.m_value2 = textField.text;
    }else{
        self.m_value3 = textField.text;
    }
    return YES;
}


@end
