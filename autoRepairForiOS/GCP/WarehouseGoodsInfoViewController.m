//
//  WarehouseGoodsInfoViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsInfoViewController.h"
#import "WarehouseGoodsSettingViewController.h"
#import "WarehouseGoodPurchaseViewController.h"
@interface WarehouseGoodsInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,WarehouseGoodsSettingViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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
//                           @"是否启用商品",
                           ];

    }
    return self;
}

- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
    [self addFooterView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:self.m_goodsInfo.m_isAddNew ? @"新增商品" : @"商品详情"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, 44)];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addFooterView
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
    [footer setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
    self.tableView.tableFooterView = footer;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, MAIN_WIDTH-20, 15)];
    [lab setText:@"图片"];
    [lab setTextColor:[UIColor blackColor]];
    [lab setTextAlignment:NSTextAlignmentLeft];
    [footer addSubview:lab];

    EGOImageView *goodsView = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 40, 100, 100)];
    goodsView.userInteractionEnabled = YES;
    [goodsView setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:self.m_goodsInfo.m_picurl] ]withDefaultImage:[UIImage imageNamed:@"goods_addpic"]];
    [footer addSubview:goodsView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPic)];
    [goodsView addGestureRecognizer:tap];
}

- (void)uploadPic
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库", nil];
    act.tag = 1;
    [act showInView:self.view];
}

- (void)addBtnClicked
{
    if(self.m_goodsInfo.m_isAddNew){
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        act.tag = 3;
        [act showInView:self.view];
    }else{
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"采购",@"保存编辑",@"删除", nil];
        act.tag = 0;
        [act showInView:self.view];
    }

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

    if(self.m_goodsInfo.m_saleprice.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"商品售价不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_goodsInfo.m_category == nil){
        [PubllicMaskViewHelper showTipViewWith:@"商品分类不能为空" inSuperView:self.view withDuration:1];
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
    edit.delegate = self;
    edit.textAlignment = NSTextAlignmentLeft;
    edit.returnKeyType = UIReturnKeyDone;
    [cell addSubview:edit];

    if(indexPath.row == 0){
        [edit setText:self.m_goodsInfo.m_name];
        [edit setPlaceholder:@"必填"];
    }else if (indexPath.row == 1){
        [edit setText:self.m_goodsInfo.m_goodsencode];
    }else if (indexPath.row == 2){
        [edit setText:self.m_goodsInfo.m_category[@"name"]];
        [edit setPlaceholder:@"必填,只能选择子分类"];
    }else if (indexPath.row == 3){
        [edit setText:self.m_goodsInfo.m_saleprice];
        edit.keyboardType = UIKeyboardTypeNumberPad;

        [edit setPlaceholder:@"必填"];
    }else if (indexPath.row == 4){
        [edit setText:self.m_goodsInfo.m_costprice];
        edit.keyboardType = UIKeyboardTypeNumberPad;

        [edit setPlaceholder:@"必填"];
    }
    else if (indexPath.row == 5){
        NSInteger productType = self.m_goodsInfo.m_productertype.integerValue;
        NSString *_type = @"";
        switch (productType) {
            case 0:
                _type = @"原厂原装";
                break;
            case 1:
                _type = @"国内品牌";
                break;
            case 2:
                _type = @"国外品牌";
                break;
            case 3:
                _type = @"副厂";
                break;
            case 4:
                _type = @"拆车";
                break;
            case 5:
                _type = @"外包加工";
                break;

            default:
                break;
        }
        [edit setText:_type];
    }else if (indexPath.row == 6){
        [edit setText:self.m_goodsInfo.m_producteraddress];
    }else if (indexPath.row == 7){
        [edit setText:self.m_goodsInfo.m_barcode];
    }else if (indexPath.row == 8){
        [edit setText:self.m_goodsInfo.m_brand];
    }else if (indexPath.row == 9){
        [edit setText:self.m_goodsInfo.m_unit];
    }else if (indexPath.row == 10){
        [edit setText:self.m_goodsInfo.m_minnum];
        [edit setPlaceholder:@"不填则没有预警提示"];
        edit.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row == 11){
        [edit setText:self.m_goodsInfo.m_applycartype];
    }else if (indexPath.row == 12){
        [edit setText:self.m_goodsInfo.m_remark];
    }else if (indexPath.row == 13){
        [edit removeFromSuperview];
        [edit setText:self.m_goodsInfo.m_isactive];
    }




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
    }else if(textField.tag == 5){
        UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"厂家类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"原厂原装",@"国内品牌",@"国外品牌",@"副厂",@"拆车",@"外包加工", nil];
        act.tag = 2;
        [act showInView:self.view];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag == 0)
    {
        self.m_goodsInfo.m_name = textField.text;
    }else if (textField.tag == 1){
        self.m_goodsInfo.m_goodsencode = textField.text;
    }else if (textField.tag == 2){

    }else if (textField.tag == 3){
        self.m_goodsInfo.m_saleprice = textField.text;
    }else if (textField.tag == 4){
        self.m_goodsInfo.m_costprice = textField.text;
    }
    else if (textField.tag == 5){
        
    }else if (textField.tag == 6){
        self.m_goodsInfo.m_producteraddress = textField.text;
    }else if (textField.tag == 7){
        self.m_goodsInfo.m_barcode = textField.text;
    }else if (textField.tag == 8){
        self.m_goodsInfo.m_brand = textField.text;
    }else if (textField.tag == 9){
        self.m_goodsInfo.m_unit = textField.text;
    }else if (textField.tag == 10){
        self.m_goodsInfo.m_minnum = textField.text;
    }else if (textField.tag == 11){
        self.m_goodsInfo.m_applycartype = textField.text;
    }else if (textField.tag == 12){
        self.m_goodsInfo.m_remark = textField.text;
    }else if (textField.tag == 13){
        self.m_goodsInfo.m_isactive = textField.text;
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
        self.m_goodsInfo.m_costprice = textField.text;
    }
    else if (textField.tag == 5){

    }else if (textField.tag == 6){
        self.m_goodsInfo.m_producteraddress = textField.text;
    }else if (textField.tag == 7){
        self.m_goodsInfo.m_barcode = textField.text;
    }else if (textField.tag == 8){
        self.m_goodsInfo.m_brand = textField.text;
    }else if (textField.tag == 9){
        self.m_goodsInfo.m_unit = textField.text;
    }else if (textField.tag == 10){
        self.m_goodsInfo.m_minnum = textField.text;
    }else if (textField.tag == 11){
        self.m_goodsInfo.m_applycartype = textField.text;
    }else if (textField.tag == 12){
        self.m_goodsInfo.m_remark = textField.text;
    }else if (textField.tag == 13){
        self.m_goodsInfo.m_isactive = textField.text;
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
    if(actionSheet.tag == 0){
        if(buttonIndex == 0){

            //查询是否有正在待采购此商品
            [HTTP_MANAGER queryOnePurchaseGoodsInfo:self.m_goodsInfo.m_id
                                     successedBlock:^(NSDictionary *succeedResult) {

                                         if([succeedResult[@"code"]integerValue] == 1){
                                             NSArray *arr = succeedResult[@"ret"];
                                             if(arr.count > 0){
                                                 WarehousePurchaseInfo *purchase = [WarehousePurchaseInfo from:[arr firstObject]];
                                                 purchase.m_isCreated = YES;
                                                 purchase.m_arrGoods = [NSMutableArray arrayWithObject:self.m_goodsInfo];
                                                 WarehouseGoodPurchaseViewController *purchaseVc = [[WarehouseGoodPurchaseViewController alloc]initWith:purchase];
                                                 [self.navigationController pushViewController:purchaseVc animated:YES];

                                             }else{
                                                 WarehousePurchaseInfo *purchase = [[WarehousePurchaseInfo alloc]init];
                                                 purchase.m_isCreated = NO;
                                                 purchase.m_arrGoods = [NSMutableArray arrayWithObject:self.m_goodsInfo];
                                                 WarehouseGoodPurchaseViewController *purchaseVc = [[WarehouseGoodPurchaseViewController alloc]initWith:purchase];
                                                 [self.navigationController pushViewController:purchaseVc animated:YES];
                                             }

                                         }

                                     } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {


                                     }];




        }else if (buttonIndex == 1){
            [self update];
        }else if (buttonIndex == 2){
            [self delete];
        }
    }else if(actionSheet.tag == 1){
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
    }else if(actionSheet.tag == 2){
        self.m_goodsInfo.m_productertype = [NSString stringWithFormat:@"%lu",buttonIndex];
        [self reloadDeals];
    }
    else if (actionSheet.tag == 3){
        [self addNew];
    }
}

- (void)addNew
{
    [self.m_currentTexfField resignFirstResponder];
    if(self.m_goodsInfo.m_name.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"商品名称不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_goodsInfo.m_saleprice.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"商品售价不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    if(self.m_goodsInfo.m_category == nil){
        [PubllicMaskViewHelper showTipViewWith:@"商品分类不能为空" inSuperView:self.view withDuration:1];
        return;
    }

    //先修改此商品在仓库的数量和进价，准备购买，入库


    [HTTP_MANAGER addNewGoodsWith:self.m_goodsInfo
                   successedBlock:^(NSDictionary *succeedResult) {

                       [self removeWaitingView];

                       if([succeedResult[@"code"]integerValue] == 1){
                            [PubllicMaskViewHelper showTipViewWith:@"添加成功,请不要忘了在商品详情页采购它哦!" inSuperView:self.view withDuration:2];
                           [self performSelector:@selector(backBtnClicked) withObject:nil afterDelay:2];
                       }else{
                           [PubllicMaskViewHelper showTipViewWith:succeedResult[@"msg"] inSuperView:self.view withDuration:1];
                       }

                   } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                       [self removeWaitingView];
                       [PubllicMaskViewHelper showTipViewWith:@"新建失败" inSuperView:self.view withDuration:1];

                   }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [self showWaitingView];
    UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:NO completion:NULL];
    NSString *path = [LocalImageHelper saveImage:image];

    NSString *fileName = [NSString stringWithFormat:@"%@",[LocalTimeUtil getCurrentTime2]];
    [HTTP_MANAGER uploadBOSFile:path
                   withFileName: fileName
                 successedBlock:^(NSDictionary *succeedResult) {

                     if([succeedResult[@"code"]integerValue] == 1)
                     {
                         NSString *newHead = succeedResult[@"url"];
                         self.m_goodsInfo.m_picurl = newHead;
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self removeWaitingView];
                             [self addFooterView];
                             [PubllicMaskViewHelper showTipViewWith:@"图片上传成功" inSuperView:self.view  withDuration:1];
                         });

                     }
                     else
                     {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self removeWaitingView];
                             [self addFooterView];
                             [PubllicMaskViewHelper showTipViewWith:@"图片上传失败" inSuperView:self.view  withDuration:1];
                         });
                     }

                 } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                     [self removeWaitingView];
                     [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view  withDuration:1];

                 }];

}

@end
