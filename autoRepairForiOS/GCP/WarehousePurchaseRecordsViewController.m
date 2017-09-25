//
//  WarehousePurchaseRecordsViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/18.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehousePurchaseRecordsViewController.h"

@interface WarehousePurchaseRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WarehousePurchaseRecordsViewController


-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"采购记录"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER queryAllPurchaseGoods:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        if([succeedResult[@"code"]integerValue] == 1)
        {
            NSArray *arr = succeedResult[@"ret"];
            NSMutableArray *arrRet = [NSMutableArray array];
            for(NSDictionary *_info in arr){
                WarehousePurchaseInfo *info = [WarehousePurchaseInfo from:_info];
                [arrRet addObject:info];
            }
            self.m_arrData = arrRet;
        }
        [self reloadDeals];

    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        [self removeWaitingView];
        [self reloadDeals];
    }];
}


#define HIGH_CELL  130
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HIGH_CELL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.accessoryType = UITableViewCellAccessoryNone;
    WarehousePurchaseInfo *puchase = [self.m_arrData objectAtIndex:indexPath.section];
    WareHouseGoods *good = [puchase.m_arrGoods firstObject];
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
    [numLab setText:[NSString stringWithFormat:@"x%@",good.m_num]];
    [cell addSubview:numLab];

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


        UILabel *buyerLab = [[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(priceLab.frame)+5,MAIN_WIDTH-10, 18)];
        [buyerLab setTextAlignment:NSTextAlignmentLeft];
        [buyerLab setTextColor:UIColorFromRGB(0x878c8b)];
        [buyerLab setFont:[UIFont systemFontOfSize:14]];
        [buyerLab setText:[NSString stringWithFormat:@"购买:%@ 时间:%@",puchase.m_buyer[@"username"],puchase.m_time]];
        [cell addSubview:buyerLab];

    if(puchase.m_saver){
        UILabel *saveLab = [[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(buyerLab.frame),MAIN_WIDTH-10, 18)];
        [saveLab setTextAlignment:NSTextAlignmentLeft];
        [saveLab setTextColor:UIColorFromRGB(0x878c8b)];
        [saveLab setFont:[UIFont systemFontOfSize:14]];
        [saveLab setText:[NSString stringWithFormat:@"入库:%@ 时间:%@",puchase.m_saver[@"username"],puchase.m_time3]];
        [cell addSubview:saveLab];
    }else{
        if(puchase.m_rejecter){
            UILabel *rejectLab = [[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(buyerLab.frame),MAIN_WIDTH-10, 18)];
            [rejectLab setTextAlignment:NSTextAlignmentLeft];
            [rejectLab setTextColor:UIColorFromRGB(0x878c8b)];
            [rejectLab setFont:[UIFont systemFontOfSize:14]];
            [rejectLab setText:[NSString stringWithFormat:@"撤销:%@ 时间:%@ 原因:%@",puchase.m_rejecter[@"username" ],puchase.m_time2,puchase.m_rejectReason]];
            [cell addSubview:rejectLab];
        }
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


@end

