//
//  EditUserViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseAddNewViewController.h"

@interface WarehouseAddNewViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSString *m_value1;
@property(nonatomic,strong)NSString *m_value2;
@property(nonatomic,strong)NSString *m_value3;
@end

@implementation WarehouseAddNewViewController
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
                           @"仓库",@"备注",
                           ];

    }
    return self;
}

- (id)initWith:(NSDictionary *)info
{
    self.m_currentInfo = [NSMutableDictionary dictionaryWithDictionary:info];
    self.m_value1 = info[@"name"];
    self.m_value2 = info[@"desc"];
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @"仓库",@"备注",
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
    [title setText: self.m_currentInfo ? @"编辑仓库" : @"新增仓库"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];

    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    if(self.m_value1.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"仓库名不能为空" inSuperView:self.view withDuration:1];
        return;
    }


    [self showWaitingView];
    if(self.m_currentInfo){
        [HTTP_MANAGER updateOneWarehouseWith:self.m_value1
                                  withRemark:self.m_value2 == nil ? @"" : self.m_value2 withId:self.m_currentInfo[@"_id"]
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
    }else{
        [HTTP_MANAGER addNewWarehouseWith:self.m_value1
                               withRemark:self.m_value2 == nil ? @"" : self.m_value2
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
        [edit setPlaceholder:@"请输入仓库名"];
    }else{
        [edit setText:self.m_value2];
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
