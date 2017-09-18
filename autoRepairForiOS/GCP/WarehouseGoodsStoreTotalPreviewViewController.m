//
//  WarehouseGoodsStoreTotalPreviewViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/18.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseGoodsStoreTotalPreviewViewController.h"

@interface WarehouseGoodsStoreTotalPreviewViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WarehouseGoodsStoreTotalPreviewViewController

- (id)init{
    if(self= [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:YES withIsNeedBottobBar:NO withIsNeedNoneView:YES]){
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"库存总览"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}



@end
