//
//  WarehouseGoodsStoreTotalPreviewViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/18.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsStoreTotalPreviewViewController.h"
#import "WarehouseGoodsInfoViewController.h"
@interface WarehouseGoodsStoreTotalPreviewViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@end

@implementation WarehouseGoodsStoreTotalPreviewViewController

- (id)init{
    if(self= [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO withIsNeedNoneView:YES]){
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"库存总览"];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-40, DISTANCE_TOP,40, HEIGHT_NAVIGATION)];
    //    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"新增商品",@"商品分类设置", nil];
    [act showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsAddNewViewController") alloc]init] animated:YES];

    }else if (buttonIndex == 1){
        [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsSettingTopTypeListViewController") alloc]init] animated:YES];
    }else{

    }
}


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


        UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-120, 40,60, 18)];
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
        [priceLab setText:[NSString stringWithFormat:@"¥ %@(系统价格)",good.m_systemPrice.length == 0 ? good.m_costprice : good.m_systemPrice]];
        [cell addSubview:priceLab];

//        UILabel *totalLab = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_WIDTH-130,CGRectGetMaxY(numLab.frame)+10,120, 18)];
//        [totalLab setTextAlignment:NSTextAlignmentRight];
//        [totalLab setTextColor:UIColorFromRGB(0x878c8b)];
//        [totalLab setFont:[UIFont systemFontOfSize:14]];
//        [totalLab setText:[NSString stringWithFormat:@"合计 %d",[good.m_costprice intValue]*[good.m_num intValue]]];
//        [cell addSubview:totalLab];

        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:navigationBG.backgroundColor];
        [cell addSubview:sep];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WareHouseGoods *good = [self.m_arrData objectAtIndex:indexPath.row];
    WarehouseGoodsInfoViewController *info = [[WarehouseGoodsInfoViewController alloc]initWith:good];
    [self.navigationController pushViewController:info animated:YES];
}

@end
