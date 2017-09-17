//
//  WarehouseSaveToStoreViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseSaveToStoreViewController.h"
#import "WarehousePurchaseEditView.h"
#import "WarehouseSettingViewController.h"
@interface WarehouseSaveToStoreViewController ()<UITableViewDelegate,UITableViewDataSource,WarehousePurchaseEditViewDelegate,WarehousePostionDelegate,UIActionSheetDelegate,UITextFieldDelegate>
@property(nonatomic,strong)WarehousePurchaseInfo *m_purchaseInfo;
@property(assign) NSInteger m_delIndex;
@property(assign) NSInteger m_selectPositionIndex;
@property(nonatomic,strong)UITextField *m_currentTextField;
@end

@implementation WarehouseSaveToStoreViewController
- (id)initWith:(WarehousePurchaseInfo *)purChaseInfo
{
    self.m_purchaseInfo = purChaseInfo;
    if(self=[super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"入库"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBtnClicked
{
    UIActionSheet *act= [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"入库", nil];
    act.tag = 1;
    [act showInView:self.view];
}

#define HIGH_CELL    120

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 && indexPath.row == 1 ? HIGH_CELL : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 5)];
    [vi setBackgroundColor:navigationBG.backgroundColor];
    return vi;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1+self.m_purchaseInfo.m_arrGoods.count;
    }else if (section == 1){
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

    [cell setBackgroundColor:[UIColor clearColor]];

    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5,15, 80, 20)];
            [tip setText:@"供应商"];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [tip setTextColor:[UIColor blackColor]];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:tip];

            UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-5,15,MAIN_WIDTH/2, 20)];
            [value setText:self.m_purchaseInfo.m_supplierInfo.m_companyName];
            [value setTextAlignment:NSTextAlignmentRight];
            [value setTextColor:[UIColor lightGrayColor]];
            [value setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:value];

            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:navigationBG.backgroundColor];
            [cell addSubview:sep];

        }else{
            WareHouseGoods *good = [self.m_purchaseInfo.m_arrGoods objectAtIndex:indexPath.row-1];
            EGOImageView * pic = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 10,60, 60)];
            [pic setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:good.m_picurl]]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
            [cell addSubview:pic];


            UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5, 10, MAIN_WIDTH/2, 18)];
            [nameLab setTextAlignment:NSTextAlignmentLeft];
            [nameLab setTextColor:[UIColor blackColor]];
            [nameLab setFont:[UIFont systemFontOfSize:16]];
            [nameLab setText:good.m_name];
            [cell addSubview:nameLab];

            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.tag = indexPath.row-1;
            [delBtn setFrame:CGRectMake(MAIN_WIDTH-30, 10, 30, 30)];
            [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:   UIControlEventTouchUpInside];
            [delBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
            [cell addSubview:delBtn];
            [delBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

            UILabel *sencodeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5, 40, MAIN_WIDTH/2, 18)];
            [sencodeLab setTextAlignment:NSTextAlignmentLeft];
            [sencodeLab setTextColor:UIColorFromRGB(0x878c8b)];
            [sencodeLab setFont:[UIFont systemFontOfSize:14]];
            [sencodeLab setText:[NSString stringWithFormat:@"编码:%@",good.m_goodsencode]];
            [cell addSubview:sencodeLab];


            UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120, 40,60, 18)];
            [numLab setTextAlignment:NSTextAlignmentRight];
            [numLab setTextColor:UIColorFromRGB(0x878c8b)];
            [numLab setFont:[UIFont systemFontOfSize:14]];
            [numLab setText:[NSString stringWithFormat:@"x%@",good.m_num]];
            [cell addSubview:numLab];


            UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            editBtn.tag = indexPath.row-1;
            [editBtn setFrame:CGRectMake(MAIN_WIDTH-30, 45, 30, 30)];
            [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:   UIControlEventTouchUpInside];
            [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
            [cell addSubview:editBtn];
            [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 10)];

            UILabel *storePositionTipLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5, 70, MAIN_WIDTH/2, 18)];
            [storePositionTipLab setTextAlignment:NSTextAlignmentLeft];
            [storePositionTipLab setTextColor:UIColorFromRGB(0x878c8b)];
            [storePositionTipLab setFont:[UIFont systemFontOfSize:14]];
            [storePositionTipLab setText:@"入库库位"];
            [cell addSubview:storePositionTipLab];


            NSString *position = [good.m_storePosition stringWithFilted:@"name"];
            UIButton *storePositionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            storePositionBtn.tag = indexPath.row-1;
            [storePositionBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            storePositionBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentLeft;
            [storePositionBtn setFrame:CGRectMake(MAIN_WIDTH-110,70, 100, 30)];
            [storePositionBtn addTarget:self action:@selector(storePositionBtnClicked:) forControlEvents:   UIControlEventTouchUpInside];
            [storePositionBtn setTitle:position.length == 0 ? @"选择库位" : position forState:UIControlStateNormal];
            [storePositionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [storePositionBtn setImage:[UIImage imageNamed:@"chevronright"] forState:UIControlStateNormal];
            [cell addSubview:storePositionBtn];
            [storePositionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];





            UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,CGRectGetMaxY(storePositionTipLab.frame)+10,120, 18)];
            [priceLab setTextAlignment:NSTextAlignmentLeft];
            [priceLab setTextColor:UIColorFromRGB(0x878c8b)];
            [priceLab setFont:[UIFont systemFontOfSize:14]];
            [priceLab setText:[NSString stringWithFormat:@"¥ %@",good.m_costprice]];
            [cell addSubview:priceLab];

            UILabel *totalLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-130,CGRectGetMaxY(storePositionTipLab.frame)+10,120, 18)];
            [totalLab setTextAlignment:NSTextAlignmentRight];
            [totalLab setTextColor:UIColorFromRGB(0x878c8b)];
            [totalLab setFont:[UIFont systemFontOfSize:14]];
            [totalLab setText:[NSString stringWithFormat:@"合计 %d",[good.m_costprice intValue]*[good.m_num intValue]]];
            [cell addSubview:totalLab];
            
            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:navigationBG.backgroundColor];
            [cell addSubview:sep];

        }

    }else if (indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5,15, 80, 20)];
        [tip setText:@"支付方式"];
        [tip setTextAlignment:NSTextAlignmentLeft];
        [tip setTextColor:[UIColor blackColor]];
        [tip setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:tip];

        UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH/2-30,15,MAIN_WIDTH/2, 20)];

        NSString *type = nil;
        switch (self.m_purchaseInfo.m_payType.integerValue) {
            case 0:
            {
                type = @"现金";
                break;
            }

            case 1:{
                type = @"银行卡";
                break;
            }
            case 2:{
                type = @"挂帐";
                break;
            }
            case 3:{
                type = @"微信";
                break;
            }
            case 4:{
                type = @"支付宝";
                break;
            }
            case 5:{
                type = @"其它";
                break;
            }
            case 6:{
                type = @"支票";
                break;
            }
            case 7:{
                type = @"转账";
                break;
            }

            default:
                break;
        }

        [value setText:self.m_purchaseInfo.m_payType.length == 0? @"选择支付方式" : type];
        [value setTextAlignment:NSTextAlignmentRight];
        [value setTextColor:[UIColor lightGrayColor]];
        [value setFont:[UIFont systemFontOfSize:15]];
        [cell addSubview:value];
    }else{
        if(indexPath.row == 0){
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5,15, 80, 20)];
            [tip setText:@"其它"];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [tip setTextColor:[UIColor blackColor]];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:tip];

            UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, MAIN_WIDTH, 0.5)];
            [sep setBackgroundColor:navigationBG.backgroundColor];
            [cell addSubview:sep];
        }else{
            UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5,15, 80, 20)];
            [tip setText:@"运费"];
            [tip setTextAlignment:NSTextAlignmentLeft];
            [tip setTextColor:[UIColor blackColor]];
            [tip setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:tip];

            UITextField *input = [[UITextField alloc]initWithFrame:CGRectMake(90, 15, MAIN_WIDTH-100, 20)];
            [input setPlaceholder:@"请输入运费"];
            [input setText:self.m_purchaseInfo.m_expressCost];
            [input setTextAlignment:NSTextAlignmentRight];
            [input setTextColor:[UIColor lightGrayColor]];
            input.delegate = self;
            [input setFont:[UIFont systemFontOfSize:15]];
            [input setReturnKeyType:UIReturnKeyDone];
            [cell addSubview:input];
            self.m_currentTextField = input;
        }
    }

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
    otherButtonTitles:@"现金",@"银行卡",@"挂账",@"微信",@"支付宝",@"其它",@"支票",@"转账", nil];
        act.tag = 0;
        [act showInView:self.view];

    }
}

- (void)storePositionBtnClicked:(UIButton *)btn
{
    self.m_selectPositionIndex = btn.tag;
    WarehouseSettingViewController *select = [[WarehouseSettingViewController alloc]initWith:self];
    [self.navigationController pushViewController:select animated:YES];
}


- (void)delBtnClicked:(UIButton *)btn
{
    self.m_delIndex = btn.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认删除?" message:@"该操作无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {

    }
    else
    {
        [self.m_purchaseInfo.m_arrGoods removeObjectAtIndex:self.m_delIndex];
        [self reloadDeals];
    }
}

- (void)editBtnClicked:(UIButton *)btn
{
    WareHouseGoods *good = [self.m_purchaseInfo.m_arrGoods objectAtIndex:btn.tag];
    WarehousePurchaseEditView *editView = [[WarehousePurchaseEditView alloc]initWith:good withDelegate:self];
    [self.view addSubview:editView];
}

#pragma mark - WarehousePurchaseEditViewDelegate
- (void)onEditCompleted:(WareHouseGoods *)newGoods
{
    [self reloadDeals];
}

#pragma mark - WarehousePostionDelegate
- (void)onWarehousePositionSelected:(NSDictionary *)positionInfo
{
    WareHouseGoods *good = [self.m_purchaseInfo.m_arrGoods objectAtIndex:self.m_selectPositionIndex];
    good.m_storePosition = positionInfo;
    self.m_purchaseInfo.m_storePosition = positionInfo;
    [self reloadDeals];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 0){
        if(buttonIndex == 8){

        }else{
            self.m_purchaseInfo.m_payType = [NSString stringWithFormat:@"%lu",buttonIndex];
            [self reloadDeals];
        }
    }else{
        if(buttonIndex == 0){//入库

            [self.m_currentTextField resignFirstResponder];
            if(self.m_purchaseInfo.m_storePosition == nil){
                [PubllicMaskViewHelper showTipViewWith:@"入库库位还未填写" inSuperView:self.view withDuration:1];
                return;
            }

            if(self.m_purchaseInfo.m_expressCost.length == 0){
                [PubllicMaskViewHelper showTipViewWith:@"运费还未填写" inSuperView:self.view withDuration:1];
                return;
            }

            [HTTP_MANAGER savePurchaseGoodsToStore:self.m_purchaseInfo
                                    successedBlock:^(NSDictionary *succeedResult) {
                                        if([succeedResult[@"code"]integerValue] == 1){
                                            for(WareHouseGoods *good in self.m_purchaseInfo.m_arrGoods){
                                                [HTTP_MANAGER saveBuyedOneGoodsWith:good
                                                                     successedBlock:^(NSDictionary *succeedResult) {

                                                } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                                }];
                                            }
                                        }

            } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

            }];

        }else{

        }


    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.m_purchaseInfo.m_expressCost = textField.text;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.m_purchaseInfo.m_expressCost = textField.text;
    return YES;
}

@end
