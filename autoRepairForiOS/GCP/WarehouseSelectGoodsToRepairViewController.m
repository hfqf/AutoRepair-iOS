//
//  WarehouseSelectGoodsToRepairViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/23.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseSelectGoodsToRepairViewController.h"

#import "WarehouseGoodsInfoViewController.h"
@interface WarehouseSelectGoodsToRepairViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property(nonatomic,copy)NSMutableDictionary *m_dicSelected;
@end

@implementation WarehouseSelectGoodsToRepairViewController

- (id)initWithSelected:(NSMutableDictionary *)selectedDic
{
    self.m_dicSelected = selectedDic;
    if(self= [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO withIsNeedNoneView:YES]){
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"选择商品"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"确认" forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    if(self.m_selectDelegate && [self.m_selectDelegate respondsToSelector:@selector(onWarehouseSelectGoodsToRepairViewControllerSelected:)]){
        [self.m_selectDelegate onWarehouseSelectGoodsToRepairViewControllerSelected:self.m_arrData];
    }
    [self backBtnClicked];
}

#pragma mark - UIActionSheetDelegate


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER getAllGoodsStoreList:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        if([succeedResult[@"code"]integerValue] == 1){
            NSMutableArray *arr = [NSMutableArray array];
            for(NSDictionary *info in succeedResult[@"ret"]){
                WareHouseGoods *good = [WareHouseGoods from:info];
                NSString *num = self.m_dicSelected[[NSString stringWithFormat:@"0_%@",good.m_name]];
                if(num.integerValue > 0){
                    good.m_selectedNum = num;
                }
                [arr addObject:good];
            }
            self.m_arrData = arr;
        }
        [self reloadDeals];
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self reloadDeals];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}


#define HIGH_CELL    90

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 ? HIGH_CELL : 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    WareHouseGoods *good = [self.m_arrData objectAtIndex:indexPath.row];
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


    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-70, 40,60, 18)];
    [numLab setTextAlignment:NSTextAlignmentRight];
    [numLab setTextColor:UIColorFromRGB(0x878c8b)];
    [numLab setFont:[UIFont systemFontOfSize:14]];
    [numLab setText:[NSString stringWithFormat:@"x%@",good.m_num]];
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
    [priceLab setText:[NSString stringWithFormat:@"¥ %@(售价)",good.m_saleprice.length == 0 ? @"0" : good.m_saleprice]];
    [cell addSubview:priceLab];

    //        UILabel *totalLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-130,CGRectGetMaxY(numLab.frame)+10,120, 18)];
    //        [totalLab setTextAlignment:NSTextAlignmentRight];
    //        [totalLab setTextColor:UIColorFromRGB(0x878c8b)];
    //        [totalLab setFont:[UIFont systemFontOfSize:14]];
    //        [totalLab setText:[NSString stringWithFormat:@"合计 %d",[good.m_costprice intValue]*[good.m_num intValue]]];
    //        [cell addSubview:totalLab];

    UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.tag = indexPath.row;
    [reduceBtn addTarget:self action:@selector(reduceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reduceBtn setFrame:CGRectMake(MAIN_WIDTH-120, CGRectGetMaxY(numLab.frame), 40, 30)];
    [reduceBtn setImage:[UIImage imageNamed:@"goods_reduce"] forState:UIControlStateNormal];
    [cell addSubview:reduceBtn];

    UILabel *serviceNeedNumLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(reduceBtn.frame), CGRectGetMaxY(numLab.frame)+5, 40, 20)];
    [serviceNeedNumLab setTextAlignment:NSTextAlignmentCenter];
    [serviceNeedNumLab setText:good.m_selectedNum.length == 0 ? @"0" : good.m_selectedNum];
    [serviceNeedNumLab setFont:[UIFont systemFontOfSize:13]];
    [serviceNeedNumLab setTextColor:[UIColor blackColor]];
    [cell addSubview:serviceNeedNumLab];

    UIButton *addNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addNumBtn.tag = indexPath.row;
    [addNumBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addNumBtn setFrame:CGRectMake(MAIN_WIDTH-40, CGRectGetMaxY(numLab.frame), 40, 30)];
    [addNumBtn setImage:[UIImage imageNamed:@"goods_add"] forState:UIControlStateNormal];
    [cell addSubview:addNumBtn];


    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];
    return cell;
}

- (void)reduceBtnClicked:(UIButton *)btn
{
    WareHouseGoods *good = [self.m_arrData objectAtIndex:btn.tag];
    NSInteger num = good.m_selectedNum.integerValue;
    if(num > 0){
        num--;
    }
    good.m_selectedNum = [NSString stringWithFormat:@"%lu",num];
    [self reloadDeals];
}

- (void)addBtnClicked:(UIButton *)btn
{
    WareHouseGoods *good = [self.m_arrData objectAtIndex:btn.tag];
    NSInteger num = good.m_selectedNum.integerValue;
    if(num == good.m_num.integerValue){
        num =  good.m_num.integerValue;
    }else{
        num++;
    }
    good.m_selectedNum = [NSString stringWithFormat:@"%lu",num];
    [self reloadDeals];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end

