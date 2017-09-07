//
//  WarehouseGoodsInfoViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsInfoViewController.h"
#import "WarehouseGoodsSettingViewController.h"
#import "WarehouseGoodsAddNewViewController.h"
@interface WarehouseGoodsInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WarehouseGoodsSettingViewControllerDelegate>
@property(nonatomic,strong)WareHouseGoods *m_goodsInfo;
@property(nonatomic,strong)UITextField *m_currentTexfField;

@end

@implementation WarehouseGoodsInfoViewController
- (id)initWith:(WareHouseGoods *)goods
{
    self.m_goodsInfo = goods;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @"商品名称",
                           @"商品编码",
                           @"分类",
                           @"售价",
                           @"成本价",
                           @"厂家类型",
                           @"产地",
                           @"条形码",
                           @"品牌",
                           @"单位",
                           @"库存预警值",
                           @"适用车型",
                           @"商品备注",
                           @"是否启用商品",
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
    [title setText:@"商品详情"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"采购",@"保存编辑",@"删除", nil];
    [act showInView:self.view];
}

- (void)delete
{

    [self showWaitingView];
    [HTTP_MANAGER delOneGoodsWith:self.m_goodsInfo.m_id
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

- (void)update
{
    [self.m_currentTexfField resignFirstResponder];
    if(self.m_goodsInfo.m_name.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"商品名称不能为空" inSuperView:self.view withDuration:1];
        return;
    }


    [self showWaitingView];
    [HTTP_MANAGER updateOneGoodsWith:self.m_goodsInfo
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

    UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10,20,80, 20)];
    [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
    [_tit setFont:[UIFont systemFontOfSize:14]];
    [_tit setText:[self.m_arrData objectAtIndex:indexPath.row]];
    [cell addSubview:_tit];
    UITextField *edit = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tit.frame), 10, MAIN_WIDTH-(CGRectGetMaxX(_tit.frame))-30, 40)];
    edit.tag = indexPath.row;
    [edit setFont:[UIFont systemFontOfSize:14]];
    if(indexPath.row == 0){
        [edit setText:self.m_goodsInfo.m_name];
        [edit setPlaceholder:@"必填"];
    }else if (indexPath.row == 1){
        [edit setText:self.m_goodsInfo.m_goodsencode];
    }else if (indexPath.row == 2){
        [edit setText:self.m_goodsInfo.m_category[@"name"]];
        [edit setPlaceholder:@"必填"];
    }else if (indexPath.row == 3){
        [edit setText:self.m_goodsInfo.m_saleprice];
        [edit setPlaceholder:@"必填"];
    }else if (indexPath.row == 4){
        [edit setText:self.m_goodsInfo.m_costprice];
        [edit setPlaceholder:@"必填"];
    }
    else if (indexPath.row == 4){
        [edit setText:self.m_goodsInfo.m_productertype];
    }else if (indexPath.row == 5){
        [edit setText:self.m_goodsInfo.m_producteraddress];
    }else if (indexPath.row == 6){
        [edit setText:self.m_goodsInfo.m_barcode];
    }else if (indexPath.row == 7){
        [edit setText:self.m_goodsInfo.m_brand];
    }else if (indexPath.row == 8){
        [edit setText:self.m_goodsInfo.m_unit];
    }else if (indexPath.row == 9){
        [edit setText:self.m_goodsInfo.m_minnum];
    }else if (indexPath.row == 10){
        [edit setText:self.m_goodsInfo.m_applycartype];
    }else if (indexPath.row == 11){
        [edit setText:self.m_goodsInfo.m_remark];
    }else if (indexPath.row == 12){
        [edit setText:self.m_goodsInfo.m_isactive];
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

    if(textField.tag == 0)
    {

    }else if (textField.tag == 2){
        WarehouseGoodsSettingViewController *add = [[WarehouseGoodsSettingViewController alloc]initForSelectType];
        add.m_selectDelegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }else{

    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 0)
    {
        self.m_goodsInfo.m_name = textField.text;
    }else if (textField.tag == 1){
        self.m_goodsInfo.m_goodsencode = textField.text;
    }else if (textField.tag == 2){
        WarehouseGoodsSettingViewController *add = [[WarehouseGoodsSettingViewController alloc]initForSelectType];
        add.m_selectDelegate = self;
        [self.navigationController pushViewController:add animated:YES];
    }else if (textField.tag == 3){
        self.m_goodsInfo.m_saleprice = textField.text;
    }else if (textField.tag == 4){
        self.m_goodsInfo.m_productertype = textField.text;
    }else if (textField.tag == 5){
        self.m_goodsInfo.m_producteraddress = textField.text;
    }else if (textField.tag == 6){
        self.m_goodsInfo.m_barcode = textField.text;
    }else if (textField.tag == 7){
        self.m_goodsInfo.m_brand = textField.text;
    }else if (textField.tag == 8){
        self.m_goodsInfo.m_unit = textField.text;
    }else if (textField.tag == 9){
        self.m_goodsInfo.m_minnum = textField.text;
    }else if (textField.tag == 10){
        self.m_goodsInfo.m_applycartype = textField.text;
    }else if (textField.tag == 11){
        self.m_goodsInfo.m_remark = textField.text;
    }else if (textField.tag == 12){
        self.m_goodsInfo.m_isactive = textField.text;
    }else if (textField.tag == 13){

    }else if (textField.tag == 14){

    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        self.m_goodsInfo.m_name = textField.text;
    }else if (textField.tag == 1){
        self.m_goodsInfo.m_goodsencode = textField.text;
    }else if (textField.tag == 2){

    }else if (textField.tag == 3){
        self.m_goodsInfo.m_saleprice = textField.text;
    }else if (textField.tag == 4){
        self.m_goodsInfo.m_productertype = textField.text;
    }else if (textField.tag == 5){
        self.m_goodsInfo.m_producteraddress = textField.text;
    }else if (textField.tag == 6){
        self.m_goodsInfo.m_barcode = textField.text;
    }else if (textField.tag == 7){
        self.m_goodsInfo.m_brand = textField.text;
    }else if (textField.tag == 8){
        self.m_goodsInfo.m_unit = textField.text;
    }else if (textField.tag == 9){
        self.m_goodsInfo.m_minnum = textField.text;
    }else if (textField.tag == 10){
        self.m_goodsInfo.m_applycartype = textField.text;
    }else if (textField.tag == 11){
        self.m_goodsInfo.m_remark = textField.text;
    }else if (textField.tag == 12){
        self.m_goodsInfo.m_isactive = textField.text;
    }else if (textField.tag == 13){

    }else if (textField.tag == 14){

    }
    return YES;
}

#pragma mark - WarehouseGoodsSettingViewControllerDelegate
- (void)onSelectGoodsType:(NSDictionary *)goodsInfo
{
    self.m_goodsInfo.m_category = goodsInfo;
    [self reloadDeals];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        WarehouseGoodsAddNewViewController *purchase = [[WarehouseGoodsAddNewViewController alloc]initWith:self.m_goodsInfo];
        [self.navigationController pushViewController:purchase animated:YES];
    }else if (buttonIndex == 1){
        [self update];
    }else{
        [self delete];
    }
}
@end
