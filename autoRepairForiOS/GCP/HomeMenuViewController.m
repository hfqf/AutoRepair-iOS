//
//  HomeMenuViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/10/28.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "HomeMenuViewController.h"
#import "MXCycleScrollView.h"
#import "SpeWebviewViewController.h"
@interface HomeMenuViewController ()<MXCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MXCycleScrollView *cycleScrollView;
@property(nonatomic,strong)NSMutableArray *m_arrAds;
@end


#define kNumCell      4
#define  HIGH_ADS     MAIN_WIDTH/2

@implementation HomeMenuViewController
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.m_arrData= @[
                          @{@"name":@"工单",
                            @"icon":@"home_gd"
                              },
                          @{@"name":@"预约单",
                            @"icon":@"home_yy"
                            },
                          @{@"name":@"客户管理",
                            @"icon":@"home_kh"
                            },
                          @{@"name":@"到期提醒",
                            @"icon":@"home_tx"
                            },
                          @{@"name":@"仓库管理",
                            @"icon":@"home_ck"
                            },
                          @{@"name":@"服务管理",
                            @"icon":@"home_fw"
                            },
                          @{@"name":@"报表统计",
                            @"icon":@"home_bb"
                            },
                          @{@"name":@"收支统计",
                            @"icon":@"home_sz"
                            },
                          @{@"name":@"汽修圈",
                            @"icon":@"home_lt"
                             },];
        [self reloadDeals];
        [HTTP_MANAGER getgHomeAdvs:^(NSDictionary *succeedResult) {
            if([succeedResult[@"code"]integerValue]==1){
                self.m_arrAds = [NSMutableArray arrayWithArray:succeedResult[@"ret"]];
                if(self.m_arrAds.count > 0){
                    self.tableView.tableHeaderView = [self headereView:succeedResult[@"ret"]];
                }
            }
        } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {

        }];
    }
    return self;
}

- (UIView *)headereView:(NSArray *)arr
{
    NSMutableArray *arrPics = [NSMutableArray array];
    for(NSDictionary *info in arr){
        [arrPics addObject:info[@"picurl"]];
    }
    self.cycleScrollView = [[MXCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HIGH_ADS) withContents:arrPics andScrollDelay:3.0];
    self.cycleScrollView.delegate = self;
    return self.cycleScrollView;
}

#pragma mark - MXCycleScrollViewDelegate
- (void)clickImageIndex:(NSInteger)index {
    NSLog(@"pageViewDidTapIndex %ld",index);
    NSDictionary *info = [self.m_arrAds objectAtIndex:index];
    SpeWebviewViewController *web = [[SpeWebviewViewController alloc]initWithUrl:info[@"url"] withTitle:info[@"title"]];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    backBtn.hidden = YES;
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    [title setTextColor:UIColorFromRGB(0x333333)];
    [title setText:[LoginUserUtil shopName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = ceil(self.m_arrData.count*1.0/kNumCell);
    return MAIN_WIDTH/kNumCell*1.2*row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:[UIColor whiteColor]];

    for(NSDictionary *info in self.m_arrData){
        NSInteger index = [self.m_arrData indexOfObject:info];
        NSInteger row = index/kNumCell;
        NSInteger coulmn = index%kNumCell;
        NSInteger width = MAIN_WIDTH/kNumCell;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        [btn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setFrame:CGRectMake(width*coulmn, row*width*1.2, width, width*1.2)];
        [btn setImage:[UIImage imageNamed:info[@"icon"]] forState:0];
        [btn setImageEdgeInsets:UIEdgeInsetsMake((width*1.2-25)/2,(width-25)/2,(width*1.2-25)/2,(width-25)/2)];
        [cell addSubview:btn];

        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, width*1.2/2+20, width, 20)];
        [tip setTextAlignment:NSTextAlignmentCenter];
        [tip setText:info[@"name"]];
        [tip setTextColor:UIColorFromRGB(0x333333)];
        [tip setFont:[UIFont systemFontOfSize:15]];
        [btn addSubview:tip];
    }

    
    return cell;
}

- (void)menuBtnClicked:(UIButton *)btn
{
    if(btn.tag == 0){
        [self.navigationController pushViewController:[[NSClassFromString(@"WorkroomListViewController") alloc]init] animated:YES];
    }else if (btn.tag == 1){
        [self.navigationController pushViewController:[[NSClassFromString(@"NewTip2ViewController") alloc]init] animated:YES];
    }else if (btn.tag == 2){
        [self.navigationController pushViewController:[[NSClassFromString(@"CustomerViewController") alloc]init] animated:YES];
    }else if (btn.tag == 3){
        [self.navigationController pushViewController:[[NSClassFromString(@"NewTipViewController") alloc]init] animated:YES];
    }else if (btn.tag == 4){
        [self.navigationController pushViewController:[[NSClassFromString(@"WareHouseManagerViewController") alloc]init] animated:YES];
    }else if (btn.tag == 5){
        [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManagerViewController") alloc]init] animated:YES];
    }else if (btn.tag == 6){
         [self.navigationController pushViewController:[[NSClassFromString(@"CountOnViewController") alloc]init] animated:YES];
    }else if (btn.tag == 7){
        [self.navigationController pushViewController:[[NSClassFromString(@"CountOnView2Controller") alloc]init] animated:YES];
    }else if (btn.tag == 8){
        [self.navigationController pushViewController:[[NSClassFromString(@"LlxViewController") alloc]init] animated:YES];
    }
}
#pragma mark - MXCycleScrollViewDelegate



@end
