//
//  WarehouseGoodPurchaseInfoViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/10.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodPurchaseInfoViewController.h"

#import "WarehousePurchaseInfo.h"
#import "WarehousePurchaseEditView.h"
#import "WarehouseGoodsInSubTypeListViewController.h"
#import "WarehouseSupplierViewController.h"
@interface WarehouseGoodPurchaseInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,WarehousePurchaseEditViewDelegate,WarehouseGoodsInSubTypeListViewControllerDelegate,WarehouseSupplierViewControllerDelegate>
@property(nonatomic,strong)WareHouseGoods *m_goodsInfo;
@property(nonatomic,strong)WarehousePurchaseInfo *m_purchaseInfo;
@property(nonatomic,strong)UITextField *m_currentTexfField;
@end

@implementation WarehouseGoodPurchaseInfoViewController
- (id)initWith:(WarehousePurchaseInfo *)puchase
{
    self.m_purchaseInfo = puchase;

    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"采购详情"];
}

- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加商品",@"确认采购", nil];
    [act showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    else if(section == 1){
        return self.m_purchaseInfo.m_arrGoods.count;
    }else{
        return 3;
    }
    return 0;
}

#define HIGH_CELL    90

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 80;
    }
    else if (indexPath.section == 1){
        return  HIGH_CELL;
    }else{
        return 60;
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];

    if(indexPath.section == 0){

        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(5,5, MAIN_WIDTH/2, 18)];
        [nameLab setTextAlignment:NSTextAlignmentLeft];
        [nameLab setTextColor:[UIColor blackColor]];
        [nameLab setFont:[UIFont boldSystemFontOfSize:16]];
        [nameLab setText:self.m_purchaseInfo.m_supplierInfo.m_companyName];
        [cell addSubview:nameLab];

        UILabel *sencodeLab = [[UILabel alloc]initWithFrame:CGRectMake(5,25, MAIN_WIDTH/2, 18)];
        [sencodeLab setTextAlignment:NSTextAlignmentLeft];
        [sencodeLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [sencodeLab setFont:[UIFont systemFontOfSize:14]];
        [sencodeLab setText:[NSString stringWithFormat:@"单据:%@",self.m_purchaseInfo.m_id]];
        [cell addSubview:sencodeLab];

        UILabel *buyerLab = [[UILabel alloc]initWithFrame:CGRectMake(5,48, MAIN_WIDTH/2, 18)];
        [buyerLab setTextAlignment:NSTextAlignmentLeft];
        [buyerLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [buyerLab setFont:[UIFont systemFontOfSize:14]];
        [buyerLab setText:[NSString stringWithFormat:@"采购员:%@",self.m_purchaseInfo.m_buyer[@"username"]]];
        [cell addSubview:buyerLab];

        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(150,48,MAIN_WIDTH-160, 18)];
        [timeLab setTextAlignment:NSTextAlignmentRight];
        [timeLab setTextColor:KEY_COMMON_GRAY_CORLOR];
        [timeLab setFont:[UIFont systemFontOfSize:14]];
        [timeLab setText:[NSString stringWithFormat:@"采购时间:%@",self.m_purchaseInfo.m_time]];
        [cell addSubview:timeLab];

    }else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        WareHouseGoods *good = [self.m_purchaseInfo.m_arrGoods objectAtIndex:indexPath.row];
        EGOImageView * pic = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 10,60, 60)];
        [pic setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:good.m_picurl]]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
        [cell addSubview:pic];


        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5, 10, MAIN_WIDTH/2, 18)];
        [nameLab setTextAlignment:NSTextAlignmentLeft];
        [nameLab setTextColor:[UIColor blackColor]];
        [nameLab setFont:[UIFont systemFontOfSize:16]];
        [nameLab setText:good.m_name];
        [cell addSubview:nameLab];

//        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        delBtn.tag = indexPath.row;
//        [delBtn setFrame:CGRectMake(MAIN_WIDTH-30, 10, 30, 30)];
//        [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:   UIControlEventTouchUpInside];
//        [delBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
//        [cell addSubview:delBtn];
//        [delBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

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
        [numLab setText:[NSString stringWithFormat:@"x%@",good.m_purchaseNum]];
        [cell addSubview:numLab];

//
//        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        editBtn.tag = indexPath.row;
//        [editBtn setFrame:CGRectMake(MAIN_WIDTH-30, 45, 30, 30)];
//        [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:   UIControlEventTouchUpInside];
//        [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
//        [cell addSubview:editBtn];
//        [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 10)];


        UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,CGRectGetMaxY(numLab.frame)+10,120, 18)];
        [priceLab setTextAlignment:NSTextAlignmentLeft];
        [priceLab setTextColor:UIColorFromRGB(0x878c8b)];
        [priceLab setFont:[UIFont systemFontOfSize:14]];
        [priceLab setText:[NSString stringWithFormat:@"¥ %@",good.m_costprice]];
        [cell addSubview:priceLab];

        UILabel *totalLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-130,CGRectGetMaxY(numLab.frame)+10,120, 18)];
        [totalLab setTextAlignment:NSTextAlignmentRight];
        [totalLab setTextColor:UIColorFromRGB(0x878c8b)];
        [totalLab setFont:[UIFont systemFontOfSize:14]];
        [totalLab setText:[NSString stringWithFormat:@"合计 %d",[good.m_costprice intValue]*[good.m_purchaseNum intValue]]];
        [cell addSubview:totalLab];

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:navigationBG.backgroundColor];
        [cell addSubview:sep];



    }else if (indexPath.section == 1){

    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10,20,80, 20)];
        [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
        [_tit setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:_tit];
        UITextField *edit = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tit.frame), 10, MAIN_WIDTH-(CGRectGetMaxX(_tit.frame))-30, 40)];
        edit.tag = indexPath.row;
        [edit setFont:[UIFont systemFontOfSize:14]];
        if (indexPath.row == 0){
            [_tit setText:@"物流公司"];
            [edit setText:self.m_purchaseInfo.m_expressCompany];
        }else if (indexPath.row == 1){
            [_tit setText:@"物流单号"];
            [edit setText:self.m_purchaseInfo.m_expressSerialId];
        }else if (indexPath.row == 2){
            [_tit setText:@"备注"];
            [edit setText:self.m_goodsInfo.m_remark];
        }
        edit.enabled = NO;
        edit.delegate = self;
        edit.textAlignment = NSTextAlignmentLeft;
        edit.returnKeyType = UIReturnKeyDone;
        [cell addSubview:edit];
//        edit.layer.cornerRadius = 2;
//        edit.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
//        edit.layer.borderWidth = 0.5;

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,59.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:navigationBG.backgroundColor];
        [cell addSubview:sep];
    }


    return cell;
}

- (void)delBtnClicked:(UIButton *)btn
{

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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){//添加商品
        NSMutableArray *arr = [NSMutableArray array];
        for(WareHouseGoods *good in self.m_purchaseInfo.m_arrGoods){
            [arr addObject:good];
        }
        WarehouseGoodsInSubTypeListViewController *add = [[WarehouseGoodsInSubTypeListViewController alloc]initWithSelectDelegate:self  withSelectedGoods:arr];
        [self.navigationController pushViewController:add animated:YES];
    }else if (buttonIndex == 1){//采购
        [self commit];
    }else{

    }
}

#pragma mark - WarehouseGoodsInSubTypeListViewControllerDelegate

- (void)onSelectGoodsArray:(NSArray *)arrSelected
{
    self.m_purchaseInfo.m_arrGoods = arrSelected;
    [self reloadDeals];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.m_currentTexfField = textField;

    if(textField.tag == 0)
    {
        [self.m_currentTexfField resignFirstResponder];
        WarehouseSupplierViewController *add = [[WarehouseSupplierViewController alloc]initWith:self];
        [self.navigationController pushViewController:add animated:YES];

    }else if (textField.tag == 2){


    }else{

    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if(textField.tag ==0){

    }else if (textField.tag == 1){
        self.m_purchaseInfo.m_expressCompany = textField.text;
    }else if (textField.tag == 2){
        self.m_purchaseInfo.m_expressSerialId = textField.text;
    }else if (textField.tag == 3){
        self.m_purchaseInfo.m_remark = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    if(textField.tag ==0){

    }else if (textField.tag == 1){
        self.m_purchaseInfo.m_expressCompany = textField.text;
    }else if (textField.tag == 2){
        self.m_purchaseInfo.m_expressSerialId = textField.text;
    }else if (textField.tag == 3){
        self.m_purchaseInfo.m_remark = textField.text;
    }
    return YES;
}

#pragma mark - WarehouseGoodsSettingViewControllerDelegate
- (void)onSelectGoodsType:(NSDictionary *)goodsInfo
{
    self.m_goodsInfo.m_category = goodsInfo;
    [self reloadDeals];
}

#pragma mark - WarehouseSupplierViewControllerDelegate
- (void)onSupplierSelected:(NSDictionary *)supplier
{
    self.m_purchaseInfo.m_supplier = supplier;
    [self reloadDeals];
}

- (void)commit
{
    [self.m_currentTexfField resignFirstResponder];
    if(self.m_purchaseInfo.m_supplier == nil){
        [PubllicMaskViewHelper showTipViewWith:@"供应商不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    self.m_purchaseInfo.m_state = @"1";
    [HTTP_MANAGER addNewPurchaseWith:self.m_purchaseInfo
                      successedBlock:^(NSDictionary *succeedResult) {
                          
                          
                          
                          
                      } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                          
                          
                          
                          
                      }];
    
}
@end

