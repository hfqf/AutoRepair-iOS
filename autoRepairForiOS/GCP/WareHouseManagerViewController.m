//
//  WareHouseManagerViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/26.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WareHouseManagerViewController.h"
#import "WarehouseItem.h"
@interface WareHouseManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WareHouseManagerViewController

-(id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO])
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.m_arrData = @[
                           @{@"category":@"库存管理",
                             @"items":@[
                                     @{@"icon":@"warehouse_zl",@"title":@"库存总览",@"type":@"5"},
//                                     @{@"icon":@"",@"title":@"库存盘点",@"type":@"6"},
                                     @{@"icon":@"warehouse_cg",@"title":@"物品采购",@"type":@"9"},
                                     @{@"icon":@"warehouse_rk",@"title":@"物品入库",@"type":@"10"},
//                                     @{@"icon":@"",@"title":@"物品领料",@"type":@"11"},
                                     @{@"icon":@"warehouse_cgjl",@"title":@"采购记录",@"type":@"8"},
                                     @{@"icon":@"warehouse_crk",@"title":@"出入库记录",@"type":@"7"},
                                     @{@"icon":@"warehouse_th",@"title": @"库存退货",@"type":@"12"},
                                     @{@"icon":@"warehouse_yj",@"title":@"库存预警",@"type":@"4"},
                                     ]},
                           @{@"category":@"库房设置",
                             @"items":@[
                                     @{@"icon":@"warehouse_gys",@"title":@"供应商管理",@"type":@"13"},
                                     @{@"icon":@"warehouse_ckgl",@"title":@"仓库管理",@"type":@"14"},
//                                     @{@"icon":@"",@"title":@"基础设置",@"type":@"15"},
                                     @{@"icon":@"warehouse_spgl",@"title":@"商品管理",@"type":@"15"},

                                     ]},
                           ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"仓库管理"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData:(BOOL)isRefresh
{
    [self reloadDeals];
}


#define HIGH_CELL  80
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *items = info[@"items"];
    return ceil(items.count*1.0/4.0)*HIGH_CELL+40;
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

    NSDictionary *info = [self.m_arrData objectAtIndex:indexPath.section];
    NSArray *items = info[@"items"];

    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(5,5,MAIN_WIDTH-10, 20)];
    [tip setText:info[@"category"]];
    [tip setTextAlignment:NSTextAlignmentLeft];
    [tip setTextColor:[UIColor blackColor]];
    [tip setFont:[UIFont boldSystemFontOfSize:18]];
    [cell addSubview:tip];

    for(NSDictionary *info in items){
        NSInteger index = [items indexOfObject:info];
        NSInteger row = index/4;
        NSInteger coulmn = index%4;
        NSInteger width = MAIN_WIDTH/4;
        WarehouseItem *item = [[WarehouseItem alloc]initWith:CGRectMake(coulmn*width, row*HIGH_CELL+30, width, HIGH_CELL) withRessource:info  withNum:0];
        [cell addSubview:item];
        item.itemBlock = ^(NSInteger selectTag) {

            switch (selectTag) {

//                case 1://待采购
//                {
//                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseWillPurchaseViewController") alloc]init] animated:YES];
//                    break;
//                }
//
//                case 2://待入库
//                {
//                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseWillSaveToStoreGoodsViewController") alloc]init] animated:YES];
//                    break;
//                }
//
//                case 3://待领料
//                {
//                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseWillTakeGoodsViewController") alloc]init] animated:YES];
//                    break;
//                }

                case 4://库存预警
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsStoreWarmingViewController") alloc]init] animated:YES];
                    break;
                }

                case 5://库存总览
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsStoreTotalPreviewViewController") alloc]init] animated:YES];
                    break;
                }

                case 6://库存盘点
                {
                    [PubllicMaskViewHelper showTipViewWith:@"敬请期待!" inSuperView:self.view withDuration:1];
                    break;
                }

                case 7://出入库记录
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodInAndOutRecordsViewController") alloc]init] animated:YES];
                    break;
                }

                case 8://采购记录
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehousePurchaseRecordsViewController") alloc]init] animated:YES];
                    break;
                }

                case 9://采购
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseWillPurchaseViewController") alloc]init] animated:YES];
                    break;
                }

                case 10://入库
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseWillSaveToStoreGoodsViewController") alloc]init] animated:YES];
                    break;
                }

                case 11://领料
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseWillTakeGoodsViewController") alloc]init] animated:YES];
                    break;
                }

                case 12://采购退货
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehousePurchaseRejectedViewController") alloc]init] animated:YES];
                    break;
                }

                case 13://供应商管理
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseSupplierViewController") alloc]init] animated:YES];
                    break;
                }

                case 14://仓库管理

                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseSettingViewController") alloc]init] animated:YES];
                    break;
                }

                case 15://商品设置
                {
                    [self.navigationController pushViewController:[[NSClassFromString(@"WarehouseGoodsSettingViewController") alloc]init] animated:YES];
                    break;
                }

                default:
                    break;
            }

        };
    }



    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


}


@end
