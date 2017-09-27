//
//  WarehouseGoodInAndOutRecordsViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/18.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodInAndOutRecordsViewController.h"

@interface WarehouseGoodInAndOutRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WarehouseGoodInAndOutRecordsViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO withIsNeedNoneView:YES])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"出入库记录"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData:(BOOL)isRefresh
{
    [self showWaitingView];
    [HTTP_MANAGER queryGoodsInOutRecoedesWith:^(NSDictionary *succeedResult) {
        [self removeWaitingView];
        if([succeedResult[@"code"]integerValue] == 1)
        {
            NSArray *arr = succeedResult[@"ret"];
            self.m_arrData = arr;
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
    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.section];
    WareHouseGoods *good = [WareHouseGoods from:info[@"goods"]];
    EGOImageView * pic = [[EGOImageView alloc]initWithFrame:CGRectMake(5,10,90, 90)];
    [pic setImageForAllSDK:[NSURL URLWithString:[LoginUserUtil contactHeadUrl:good.m_picurl]]withDefaultImage:[UIImage imageNamed:@"app_icon"]];
    [cell addSubview:pic];


    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(pic.frame)+5,100, 18)];
    [nameLab setTextAlignment:NSTextAlignmentLeft];
    [nameLab setTextColor:[UIColor blackColor]];
    [nameLab setFont:[UIFont systemFontOfSize:12]];
    [nameLab setText:good.m_name];
    [cell addSubview:nameLab];

    UILabel *sencodeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,10, MAIN_WIDTH/2, 18)];
    [sencodeLab setTextAlignment:NSTextAlignmentLeft];
    [sencodeLab setTextColor:UIColorFromRGB(0x878c8b)];
    [sencodeLab setFont:[UIFont systemFontOfSize:14]];
    [sencodeLab setText:[NSString stringWithFormat:@"编码:%@",good.m_goodsencode]];
    [cell addSubview:sencodeLab];


    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, HIGH_CELL-0.5, MAIN_WIDTH, 0.5)];
    [sep setBackgroundColor:navigationBG.backgroundColor];
    [cell addSubview:sep];


    UILabel *buyerLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,CGRectGetMaxY(sencodeLab.frame)+5,MAIN_WIDTH-10-(CGRectGetMaxX(pic.frame)+5), 18)];
    [buyerLab setTextAlignment:NSTextAlignmentLeft];
    [buyerLab setTextColor:UIColorFromRGB(0x878c8b)];
    [buyerLab setFont:[UIFont systemFontOfSize:14]];
    NSInteger type = [info[@"type"] integerValue];
    NSString *_type = @"";
//    1采购入库 2开单出库,3工单取消或删除入库,4采购退货出库
    if(type == 1){
        _type = @"采购入库";
    }else if(type == 2){
        _type = @"开单出库";
    }else if(type == 3){
        _type = @"工单取消或删除入库";
    }else if(type == 4){
        _type = @"采购退货出库";
    }else if(type == 5){

    }
    [buyerLab setText:[NSString stringWithFormat:@"操作:%@ 数量:%@",_type,info[@"num"]]];
    [cell addSubview:buyerLab];

    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,CGRectGetMaxY(buyerLab.frame)+5,MAIN_WIDTH-10-(CGRectGetMaxX(pic.frame)+5), 18)];
    [timeLab setTextAlignment:NSTextAlignmentLeft];
    [timeLab setTextColor:UIColorFromRGB(0x878c8b)];
    [timeLab setFont:[UIFont systemFontOfSize:14]];
    [timeLab setText:[NSString stringWithFormat:@"操作时间:%@",info[@"time"]]];
    [cell addSubview:timeLab];

    UILabel *dealerLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pic.frame)+5,CGRectGetMaxY(timeLab.frame)+5,MAIN_WIDTH-10-(CGRectGetMaxX(pic.frame)+5), 18)];
    [dealerLab setTextAlignment:NSTextAlignmentLeft];
    [dealerLab setTextColor:UIColorFromRGB(0x878c8b)];
    [dealerLab setFont:[UIFont systemFontOfSize:14]];
    [dealerLab setText:[NSString stringWithFormat:@"操作人员:%@",info[@"dealer"][@"username"]]];
    [cell addSubview:dealerLab];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


@end


