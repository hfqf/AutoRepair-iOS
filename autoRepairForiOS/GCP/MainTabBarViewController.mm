//
//  MainTabBarViewController.m
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//


#import "MainTabBarViewController.h"
#import "TabbarButtonsBGView.h"
#import "NewTipViewController.h"
#import "CustomerViewController.h"
#import "RepairPrintViewController.h"
#import "SettingViewController.h"
#import "CountOnViewController.h"
#import "BHBItem.h"
#import "BHBPopView.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "WorkroomListViewController.h"
#import "HomeMenuViewController.h"
@interface MainTabBarViewController ()<AipOcrDelegate,UIActionSheetDelegate>
{
    
}
@property(nonatomic,strong)TabbarButtonsBGView * m_tabbar;


@end

@implementation MainTabBarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self)
    {
      
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initViewControllers];
    //第一次进来默认是选互动对话
    [self.m_tabbar refreshWithCurrentSelected:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#define NUM_TAB 2
#pragma mark -  BaseViewControllerDelegate

- (void)initData
{
    //TODO
}



//自定义头部视图
- (void)initView
{
    NSMutableArray *arrTitle= [NSMutableArray array];
    NSMutableArray *arrUnSelectedImg = [NSMutableArray array];
    NSMutableArray *arrSelectedImg = [NSMutableArray array];
    for(int i=0;i<NUM_TAB;i++)
    {
        NSString *title =  nil;
        NSString *unSelectedImg = nil;
        NSString *selectedImg = nil;
        if(i==0)
        {
            title = @"工作台";
            unSelectedImg = @"tab_work_un";
            selectedImg = @"tab_work_on";
        }
        else
        {
            title = @"我的";
            unSelectedImg = @"tab_set_un";
            selectedImg = @"tab_set_on";
        }
        [arrTitle addObject:title];
        [arrUnSelectedImg addObject:unSelectedImg];
        [arrSelectedImg addObject:selectedImg];
    }
    
    TabbarButtonsBGView * tabar = [[TabbarButtonsBGView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM, MAIN_WIDTH, HEIGHT_MAIN_BOTTOM) withTitleArr:arrTitle withUnSelectedImgArray:arrUnSelectedImg withSelectedArr:arrSelectedImg withButtonNum:NUM_TAB];
    tabar.m_delegate = self;
    [self.view addSubview:tabar];
    self.m_tabbar = tabar;
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake((MAIN_WIDTH-50)/2, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM-60, 50, 50)];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"ic_tabbar_compose_icon_add_highlighted"] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
}


- (void)addBtnClicked
{
    BHBItem * item0 = [[BHBItem alloc]initWithTitle:@"扫描车牌" Icon:@"ic_tabbar_compose_camera"];
//    BHBItem * item1 = [[BHBItem alloc]initWithTitle:@"手动添加客户" Icon:@"ic_tabbar_compose_weibo"];
//    BHBItem * item2 = [[BHBItem alloc]initWithTitle:@"添加维修记录" Icon:@"ic_tabbar_compose_icon_add_highlighted"];
//
//    BHBItem * item3 = [[BHBItem alloc]initWithTitle:@"仓库管理" Icon:@"item_warehouse"];
//    BHBItem * item4 = [[BHBItem alloc]initWithTitle:@"服务管理" Icon:@"item_service"];

    //添加popview
    [BHBPopView showToView:self.view.window
                 withItems:@[item0]
            andSelectBlock:^(BHBItem *item) {
                if ([item isKindOfClass:[BHBGroup class]]) {
                    NSLog(@"选中%@分组",item.title);
                }else{
                    NSLog(@"选中%@项",item.title);
                    if([item.title isEqualToString:@"扫描车牌"])
                    {
                        UIViewController * vc = [AipGeneralVC ViewControllerWithDelegate:self];
                        [self presentViewController:vc animated:YES completion:nil];
                        
                    }else if([item.title isEqualToString:@"手动添加客户"])
                    {
                        [self selectWithIndex:2];
                        NSArray *arr = self.viewControllers;
                        for(UIViewController *vc in arr){
                            if([vc isKindOfClass:NSClassFromString(@"CustomerViewController")]){
                                CustomerViewController *target = (CustomerViewController *)vc;
                                [target addBtnClicked];
                            }
                        }
                        
                    }else if([item.title isEqualToString:@"添加维修记录"])
                    {
                        [self selectWithIndex:0];
                        NSArray *arr = self.viewControllers;
                        for(UIViewController *vc in arr){
                            if([vc isKindOfClass:NSClassFromString(@"WorkroomListViewController")]){
                                WorkroomListViewController *target = (WorkroomListViewController *)vc;
                                [target addBtnClicked];
                            }
                        }
                    }else if([item.title isEqualToString:@"仓库管理"]){
                        [self.navigationController pushViewController:[[NSClassFromString(@"WareHouseManagerViewController") alloc]init] animated:YES];
                    }else if([item.title isEqualToString:@"服务管理"]){
                            [self.navigationController pushViewController:[[NSClassFromString(@"ServiceManagerViewController") alloc]init] animated:YES];
                    }


                }
            }];
    
}

//生成tabbar子ViewController
- (void)initViewControllers
{
    HomeMenuViewController *vc0 = [[HomeMenuViewController alloc]init];
    vc0.m_delegate = self;
//
//    NewTipViewController *vc1 = [[NewTipViewController alloc]init];
//    vc1.m_delegate = self;
//
//    CustomerViewController *vc2 = [[CustomerViewController alloc]init];
//    vc2.m_delegate = self;
//
//    CountOnViewController *vc3 = [[CountOnViewController alloc]init];
//    vc3.m_delegate = self;
//
    SettingViewController *vc4 = [[SettingViewController alloc]init];
    vc4.m_delegate = self;
    self.viewControllers = @[vc0,vc4];
}

//选择了第几个一级界面
- (void)selectWithIndex:(int)index
{
    self.selectedIndex = index;
    [self.m_tabbar refreshWithCurrentSelected:index];
}

#pragma mark -public

- (void)showWaitingView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.minSize  = CGSizeMake(80, 80);
    UIImageView *waitView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,80, 80)];
    [waitView setImage:[UIImage imageNamed:@"Icon@2x"]];
    hud.customView = waitView;
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:100];
}

- (void)removeWaitingView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - TabbarButtonsBGViewDelegate
- (void)onSelectedWithButtonIndex:(int)index
{
    [self selectWithIndex:index];
}



#pragma mark AipOcrResultDelegate

- (void)ocrOnGeneralSuccessful:(id)result {
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            for(NSDictionary *obj in result[@"words_result"]){
                [message appendFormat:@"%@", obj[@"words"]];
            }
        }else{
            [message appendFormat:@"%@", result];
        }
        
        NSArray *arr = result[@"words_result"];
        if(arr.count == 0){
            [[[UIAlertView alloc] initWithTitle:@"无识别结果,请尝试更换角度和距离" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            return ;
        }
        UIActionSheet *act = [[UIActionSheet alloc]init];
        act.delegate = self;
        act.title = @"请选择识别结果";
        for(NSDictionary *info in arr){
            [act addButtonWithTitle:info[@"words"]];
        }
        [act showInView:self.view];
    }];
    
}

- (void)ocrOnFail:(NSError *)error {
    NSLog(@"%@", error);
    NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"识别失败,请尝试更换角度和距离" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *ret = [actionSheet buttonTitleAtIndex:buttonIndex];
    [[NSNotificationCenter defaultCenter]postNotificationName:KEY_AUTO_ADD_CONTACT object:ret];
    [self selectWithIndex:1];
}
@end
