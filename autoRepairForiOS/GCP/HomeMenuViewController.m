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
#define  HIGH_ADS     120

@implementation HomeMenuViewController
- (id)init
{
    if(self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES]){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if(![LoginUserUtil isEmployeeLogin]){
            self.m_arrData=
                @[
                  @{@"name":@"工单",
                    @"icon":@"home_gd",
                    @"class":@"WorkroomListViewController"
                    },
                  @{@"name":@"预约单",
                    @"icon":@"home_yy",
                    @"class":@"NewTip2ViewController"
                    },
                  @{@"name":@"客户管理",
                    @"icon":@"home_kh",
                    @"class":@"CustomerViewController"
                    },
                  @{@"name":@"到期提醒",
                    @"icon":@"home_tx",
                    @"class":@"NewTipViewController"
                    },
                  @{@"name":@"仓库管理",
                    @"icon":@"home_ck",
                    @"class":@"WareHouseManagerViewController"
                    },
                  @{@"name":@"服务管理",
                    @"icon":@"home_fw",
                    @"class":@"ServiceManagerViewController"
                    },
                  @{@"name":@"报表统计",
                    @"icon":@"home_bb",
                    @"class":@"CountOnViewController"
                    },
                  @{@"name":@"收支统计",
                    @"icon":@"home_sz",
                    @"class":@"CountOnView2Controller"
                    },
                  @{@"name":@"汽修圈",
                    @"icon":@"home_lt",
                    @"class":@"LlxViewController"
                    },
                  @{@"name":@"员工管理",
                    @"icon":@"home_yg",
                    @"class":@"EmployeeListViewController"
                    },
                  ];
        }else{
            self.m_arrData =     @[
                                   @{@"name":@"工单",
                                     @"icon":@"home_gd",
                                     @"class":@"WorkroomListViewController"
                                     },
                                   @{@"name":@"预约单",
                                     @"icon":@"home_yy",
                                     @"class":@"NewTip2ViewController"
                                     },
                                   @{@"name":@"客户管理",
                                     @"icon":@"home_kh",
                                     @"class":@"CustomerViewController"
                                     },
                                   @{@"name":@"到期提醒",
                                     @"icon":@"home_tx",
                                     @"class":@"NewTipViewController"
                                     },
                                   @{@"name":@"汽修圈",
                                     @"icon":@"home_lt",
                                     @"class":@"LlxViewController"
                                     },];
        }

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
    return MAIN_WIDTH/kNumCell*1*row;
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
        [btn setFrame:CGRectMake(width*coulmn, row*width*1, width, width*1)];
        [btn setImage:[UIImage imageNamed:info[@"icon"]] forState:0];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(((width*1-25)/2)-10,(width-25)/2,((width*1-25)/2)+10,(width-25)/2)];
        [cell addSubview:btn];

        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, width*1/2+10, width, 20)];
        [tip setTextAlignment:NSTextAlignmentCenter];
        [tip setText:info[@"name"]];
        [tip setTextColor:UIColorFromRGB(0x333333)];
        [tip setFont:[UIFont systemFontOfSize:13]];
        [btn addSubview:tip];
    }

    
    return cell;
}

- (void)menuBtnClicked:(UIButton *)btn
{
    NSDictionary *info = self.m_arrData[btn.tag];
    [self.navigationController pushViewController:[[NSClassFromString(info[@"class"]) alloc]init] animated:YES];
}
#pragma mark - MXCycleScrollViewDelegate



@end
