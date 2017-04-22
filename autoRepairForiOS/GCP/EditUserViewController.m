//
//  EditUserViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "EditUserViewController.h"

@interface EditUserViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

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
                            @"用户名"
                           ];
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
    
    UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10,20,80, 20)];
    [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
    [_tit setFont:[UIFont systemFontOfSize:16]];
    [_tit setText:[self.m_arrData objectAtIndex:indexPath.row]];
    [cell addSubview:_tit];
    UITextField *edit = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tit.frame)+10, 10, MAIN_WIDTH-(CGRectGetMaxX(_tit.frame)+10)-30, 40)];
    edit.tag = indexPath.row;
    [edit setText:[LoginUserUtil userName]];
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
    if(textField.tag == 0)
    {
        if(textField.text.length == 0)
        {
            [PubllicMaskViewHelper showTipViewWith:@"用户名不能为空" inSuperView:self.view withDuration:1];
            return NO;
        }
        [self showWaitingView];
        [HTTP_MANAGER updateUserName:textField.text
                      successedBlock:^(NSDictionary *succeedResult) {
                          [self removeWaitingView];
                          if([succeedResult[@"code"]integerValue] == 1)
                          {
                              [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:KEY_AUTO_NAME];
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
    return YES;
}

@end
