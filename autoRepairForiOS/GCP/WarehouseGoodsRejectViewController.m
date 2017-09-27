//
//  WarehouseGoodsRejectViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/24.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsRejectViewController.h"
#import "WarehousePurchaseInfo.h"
#import "WarehousePurchaseEditView.h"
#import "WarehouseGoodsInSubTypeListViewController.h"
#import "WarehouseSupplierViewController.h"
@interface WarehouseGoodsRejectViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,WarehousePurchaseEditViewDelegate,WarehouseGoodsInSubTypeListViewControllerDelegate,WarehouseSupplierViewControllerDelegate>
@property(nonatomic,strong)WareHouseGoods *m_goodsInfo;
@property(nonatomic,strong)UITextField *m_currentTexfField;
@end

@implementation WarehouseGoodsRejectViewController
- (id)initWith:(WareHouseGoods *)good
{
    self.m_goodsInfo = good;
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
    [title setText:@"退货"];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退货", nil];
    [act showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return 1;
    }
    return 0;
}

#define HIGH_CELL    90

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? HIGH_CELL : 60;
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        WareHouseGoods *good = self.m_goodsInfo;
        EGOImageView * pic = [[EGOImageView alloc]initWithFrame:CGRectMake(5, 10,60, 60)];
        [pic setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:good.m_picurl]]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
        [cell addSubview:pic];


        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5, 10, MAIN_WIDTH/2, 18)];
        [nameLab setTextAlignment:NSTextAlignmentLeft];
        [nameLab setTextColor:[UIColor blackColor]];
        [nameLab setFont:[UIFont systemFontOfSize:16]];
        [nameLab setText:good.m_name];
        [cell addSubview:nameLab];

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
        [numLab setText:[NSString stringWithFormat:@"x%@",good.m_num.length == 0 ? @"0" : good.m_num ]];
        [cell addSubview:numLab];


        UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,CGRectGetMaxY(numLab.frame)+10,120, 18)];
        [priceLab setTextAlignment:NSTextAlignmentLeft];
        [priceLab setTextColor:UIColorFromRGB(0x878c8b)];
        [priceLab setFont:[UIFont systemFontOfSize:14]];
        [priceLab setText:[NSString stringWithFormat:@"进价 : ¥ %@",good.m_costprice]];
        [cell addSubview:priceLab];


        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:navigationBG.backgroundColor];
        [cell addSubview:sep];



    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10,20,80, 20)];
        [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
        [_tit setFont:[UIFont systemFontOfSize:14]];
        [cell addSubview:_tit];
        UITextField *edit = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tit.frame), 10, MAIN_WIDTH-(CGRectGetMaxX(_tit.frame))-30, 40)];
        edit.tag = indexPath.row;
        [self.m_currentTexfField setEnabled:YES];

        [edit setFont:[UIFont systemFontOfSize:14]];
        if(indexPath.row == 0){
            [edit resignFirstResponder];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [_tit setText:@"退货数量"];
            edit.returnKeyType = UIReturnKeyDone;
            [edit setText:self.m_goodsInfo.m_rejectNum];
            [edit setPlaceholder:@"必填"];
        }else if (indexPath.row == 1){
            [_tit setText:@"退货原因"];
            [edit setText:self.m_goodsInfo.m_rejectReason];
        }
        edit.delegate = self;
        edit.textAlignment = NSTextAlignmentLeft;
        edit.returnKeyType = UIReturnKeyDone;
        [cell addSubview:edit];
        edit.layer.cornerRadius = 2;
        edit.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        edit.layer.borderWidth = 0.5;

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0,59.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:navigationBG.backgroundColor];
        [cell addSubview:sep];
    }


    return cell;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(buttonIndex == 0){
        [self commit];
    }
    //    if(buttonIndex == 0){//添加商品
    //        NSMutableArray *arr = [NSMutableArray array];
    //        for(WareHouseGoods *good in self.m_purchaseInfo.m_arrGoods){
    //            [arr addObject:good];
    //        }
    //        WarehouseGoodsInSubTypeListViewController *add = [[WarehouseGoodsInSubTypeListViewController alloc]initWithSelectDelegate:self  withSelectedGoods:arr];
    //        [self.navigationController pushViewController:add animated:YES];
    //    }else if (buttonIndex == 1){//采购
    //        [self commit];
    //    }else{
    //
    //    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if(textField.tag ==0){
        self.m_goodsInfo.m_rejectNum = textField.text;
    }else if (textField.tag == 1){
        self.m_goodsInfo.m_rejectReason = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag ==0){
        self.m_goodsInfo.m_rejectNum = textField.text;
    }else if (textField.tag == 1){
        self.m_goodsInfo.m_rejectReason = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.m_currentTexfField = textField;
    return YES;
}

- (void)commit
{
    [self.m_currentTexfField resignFirstResponder];
    if(self.m_goodsInfo.m_rejectNum.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"退货数目不能为空" inSuperView:self.view  withDuration:1];
        return;
    }

    if(self.m_goodsInfo.m_rejectNum.integerValue == 0){
        [PubllicMaskViewHelper showTipViewWith:@"退货数目不能为0" inSuperView:self.view  withDuration:1];
        return;
    }
//
//    if(self.m_goodsInfo.m_rejectReason.length == 0){
//        [PubllicMaskViewHelper showTipViewWith:@"退货原因不能为空" inSuperView:self.view  withDuration:1];
//        return;
//    }

    if(self.m_goodsInfo.m_rejectNum.integerValue > self.m_goodsInfo.m_num.integerValue){
        [PubllicMaskViewHelper showTipViewWith:@"退货数量不能大于库存数量" inSuperView:self.view  withDuration:1];
        return;
    }
    [self updateGoodsInfo];

}

- (void)updateGoodsInfo
{
    [self showWaitingView];
    self.m_goodsInfo.m_num = [NSString stringWithFormat:@"%lu",self.m_goodsInfo.m_num.integerValue- self.m_goodsInfo.m_rejectNum.integerValue];
    [HTTP_MANAGER updateOneGoodsForRejectWith:self.m_goodsInfo
                                  successedBlock:^(NSDictionary *succeedResult) {
                                      [self removeWaitingView];
                                      if([succeedResult[@"code"]integerValue] ==1 ){

                                          //保存出入库记录
                                          [HTTP_MANAGER addNewGoodsInOutRecoedeWith:@"4"
                                                                          withRemak:@""
                                                                        withGoodsId:self.m_goodsInfo.m_id
                                                                            withNum:self.m_goodsInfo.m_rejectNum
                                                                     successedBlock:^(NSDictionary *succeedResult) {

                                                                     } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

                                                                     }];

                                      }
                                      [self backBtnClicked];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self backBtnClicked];
    }];

}
@end


