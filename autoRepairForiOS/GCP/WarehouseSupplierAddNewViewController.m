//
//  EditUserViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseSupplierAddNewViewController.h"

@interface WarehouseSupplierAddNewViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *m_value1;
@property(nonatomic,strong)NSString *m_value2;
@property(nonatomic,strong)NSString *m_value3;
@property(nonatomic,strong)NSString *m_value4;
@property(nonatomic,strong)NSString *m_value5;
@property(nonatomic,strong)UITextField *m_currentTexfField;
@end

@implementation WarehouseSupplierAddNewViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @"供应商",@"联系人",@"手机号",@"地址",@"备注",
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
    [title setText:@"新增供应商"];

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
    [self.m_currentTexfField resignFirstResponder];

    if(self.m_value1.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"供应商不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_value2.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"联系人不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_value3.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"手机号不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    [self showWaitingView];
    [HTTP_MANAGER addNewWarehouseSupplierWith:self.m_value1
                                     withName:self.m_value2
                                      withTel:self.m_value3
                                  withAddress:self.m_value4
                                   withRemark:self.m_value5
                               successedBlock:^(NSDictionary *succeedResult) {
                           [self removeWaitingView];
                           if([succeedResult[@"code"]integerValue] == 1){
                               [self.navigationController popViewControllerAnimated:YES];
                           }else{
                               [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                           }

                       } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                           [self removeWaitingView];
                           [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];

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
    UITextField *edit = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tit.frame), 10, MAIN_WIDTH-(CGRectGetMaxX(_tit.frame))-30, 40)];
    edit.tag = indexPath.row;
    [edit setFont:[UIFont systemFontOfSize:14]];
    if(indexPath.row == 0){
        [edit setText:self.m_value1];
        [edit setPlaceholder:@"必填,请输入供应商"];
    }else if (indexPath.row == 1){
        [edit setText:self.m_value2];
        [edit setPlaceholder:@"必填,请输入联系人"];
    }else if (indexPath.row == 2){
        [edit setText:self.m_value3];
        [edit setPlaceholder:@"必填,请输入手机号"];
    }else if (indexPath.row == 3){
        [edit setText:self.m_value4];
        [edit setPlaceholder:@"请输入地址"];
    }else{
        [edit setText:self.m_value5];
        [edit setPlaceholder:@"请输入备注"];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.m_currentTexfField = textField;
    return YES;
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
    }else if (textField.tag == 2)
    {
        self.m_value3 = textField.text;
    }else if (textField.tag == 3)
    {
        self.m_value4 = textField.text;
    }
    else{
        self.m_value5 = textField.text;
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
    }else if (textField.tag == 2)
    {
        self.m_value3 = textField.text;
    }else if (textField.tag == 3)
    {
        self.m_value4 = textField.text;
    }else{
        self.m_value5 = textField.text;
    }
    return YES;
}


@end
