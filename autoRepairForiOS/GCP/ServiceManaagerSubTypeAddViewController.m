//
//  ServiceManaagerSubTypeAddViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/19.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ServiceManaagerSubTypeAddViewController.h"

@interface ServiceManaagerSubTypeAddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSString *m_value2;
@property (nonatomic,strong) NSDictionary *m_servicInfo;
@end

@implementation ServiceManaagerSubTypeAddViewController

- (id)initWithServiceInfo:(NSDictionary *)serviceInfo
{
    self.m_servicInfo = serviceInfo;
    self.m_value1 = serviceInfo[@"name"];
    self.m_value2 = serviceInfo[@"price"];
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @"服务名称",
                           @"服务价格"
                           ];

    }
    return self;
}
- (id)initWith:(NSDictionary *)info
{
    self.m_parentInfo = info;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @"服务名称",
                           @"服务价格"
                           ];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_parentInfo? @"新增服务" : @"服务详情"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 0)
    {
        self.m_value1 = textField.text;
    }else{
        self.m_value2 = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 0)
    {
        self.m_value1 = textField.text;
    }else{
        self.m_value2 = textField.text;
    }
    return YES;
}

- (void)addBtnClicked
{
    [self.m_currentTexfField resignFirstResponder];
    if(self.m_value1.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"服务名称不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_value2.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"服务价格不能为空" inSuperView:self.view withDuration:1];
        return;
    }


    [self showWaitingView];
    if(self.m_servicInfo){


        [HTTP_MANAGER updateOneServiceSubTypeWith:self.m_value1
                                        withPrice:self.m_value2
                                           withId:self.m_servicInfo[@"_id"]
                                successedBlock:^(NSDictionary *succeedResult) {

                                    [self removeWaitingView];
                                    if([succeedResult[@"code"]integerValue] == 1){
                                        [self backBtnClicked];
                                    }else{
                                        [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];
                                    }

                                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                    [self removeWaitingView];
                                    [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];

                                }];


    }else{

        [HTTP_MANAGER addNewServiceSubTypeWith:self.m_value1
                                     withPrice:self.m_value2
                                     withTopId:self.m_parentInfo[@"_id"]
                                successedBlock:^(NSDictionary *succeedResult) {

                                    if([succeedResult[@"code"]integerValue] == 1){

                                        NSMutableArray *arrSub = [NSMutableArray arrayWithArray:self.m_parentInfo[@"subtype"]];
                                        [arrSub addObject:succeedResult[@"ret"][@"_id"]];

                                        [HTTP_MANAGER addNewServiceTopTypeRefWith:arrSub
                                                                        withTopId:self.m_parentInfo[@"_id"] successedBlock:^(NSDictionary *succeedResult) {

                                                                            [self removeWaitingView];
                                                                            if([succeedResult[@"code"]integerValue] == 1){
                                                                                [self backBtnClicked];

                                                                            }else{
                                                                                [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                                                                            }

                                                                        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                                                                            [self removeWaitingView];
                                                                            [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];
                                                                        }];

                                    }else{
                                        [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];
                                    }

                                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                    [self removeWaitingView];
                                    [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];

                                }];

    }

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
        [edit setPlaceholder:@"请输入服务名称"];
    }else{
        [edit setText:self.m_value2];
        [edit setPlaceholder:@"请输入服务价格"];
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

@end
