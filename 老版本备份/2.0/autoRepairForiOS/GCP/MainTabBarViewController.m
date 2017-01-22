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
#import "SearchViewController.h"
#import "SettingViewController.h"
@interface MainTabBarViewController ()
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

#define NUM_TAB 4
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
        //todo 背景图
        if(i==0)
        {
            title = @"提醒";
            unSelectedImg = @"tabbar_bottom1_un@2x";
            selectedImg = @"tabbar_bottom1_on@2x";
        }else if (i==1)
        {
            title = @"客户";
            unSelectedImg = @"tabbar_bottom2_un@2x";
            selectedImg = @"tabbar_bottom2_on@2x";
        }
        else if (i==2)
        {
            title = @"查询";
            unSelectedImg =  @"tabbar_bottom3_un@2x";
            selectedImg = @"tabbar_bottom3_on@2x";
        }
        else
        {
            title = @"公告";
            unSelectedImg = @"tabbar_bottom4_un@2x";
            selectedImg = @"tabbar_bottom4_on@2x";
        }
        [arrTitle addObject:title];
        [arrUnSelectedImg addObject:unSelectedImg];
        [arrSelectedImg addObject:selectedImg];
    }
    
    TabbarButtonsBGView * tabar = [[TabbarButtonsBGView alloc]initWithFrame:CGRectMake(0, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM, MAIN_WIDTH, HEIGHT_MAIN_BOTTOM) withTitleArr:arrTitle withUnSelectedImgArray:arrUnSelectedImg withSelectedArr:arrSelectedImg withButtonNum:NUM_TAB];
    tabar.m_delegate = self;
    [self.view addSubview:tabar];
    self.m_tabbar = tabar;
    
}

//生成tabbar子ViewController
- (void)initViewControllers
{
    NewTipViewController *vc1 = [[NewTipViewController alloc]init];
    vc1.m_delegate = self;
    
    CustomerViewController *vc2 = [[CustomerViewController alloc]init];
    vc2.m_delegate = self;
    
    SearchViewController *vc3 = [[SearchViewController alloc]init];
    vc3.m_delegate = self;
    
    SettingViewController *vc4 = [[SettingViewController alloc]init];
    vc4.m_delegate = self;
    self.viewControllers = @[vc1,vc2,vc3,vc4];
}

//选择了第几个一级界面
- (void)selectWithIndex:(int)index
{
    self.selectedIndex = index;
    [self.m_tabbar refreshWithCurrentSelected:index];
}

#pragma mark - TabbarButtonsBGViewDelegate
- (void)onSelectedWithButtonIndex:(int)index
{
    [self selectWithIndex:index];
}


@end
