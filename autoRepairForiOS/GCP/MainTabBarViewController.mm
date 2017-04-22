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
#import "BHBItem.h"
#import "BHBPopView.h"
#import "UIViewController+MVSPhotoPickerManager.h"
#import "XYPlateRecognizeUtil.h"
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
            title = @"记录";
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
            title = @"统计";
            unSelectedImg =  @"tabbar_bottom3_un@2x";
            selectedImg = @"tabbar_bottom3_on@2x";
        }
        else
        {
            title = @"我的";
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
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake((MAIN_WIDTH-50)/2, MAIN_HEIGHT-HEIGHT_MAIN_BOTTOM-60, 50, 50)];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"ic_add_note_normal"] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
}


- (void)addBtnClicked
{
    BHBItem * item0 = [[BHBItem alloc]initWithTitle:@"扫描车牌添加客户" Icon:@"ic_tabbar_compose_camera"];
    BHBItem * item1 = [[BHBItem alloc]initWithTitle:@"手动添加客户" Icon:@"ic_tabbar_compose_weibo"];
    BHBItem * item2 = [[BHBItem alloc]initWithTitle:@"添加维修记录" Icon:@"ic_tabbar_compose_icon_add_highlighted"];
    
    //添加popview
    [BHBPopView showToView:self.view.window
                 withItems:@[item0,item1,item2]
            andSelectBlock:^(BHBItem *item) {
                if ([item isKindOfClass:[BHBGroup class]]) {
                    NSLog(@"选中%@分组",item.title);
                }else{
                    NSLog(@"选中%@项",item.title);
                    if([item.title isEqualToString:@"扫描车牌添加客户"])
                    {
                        [self showPhotoPickerSheetTitle:@"尽量拉近距离,调正角度,可提高识别率" message:nil needOpenFrontCamera:NO cameraActionTitle:@"拍照" photoLibraryActionTitle:@"从相册中选取" canOpenLibrary:YES complete:^(NSArray *assetsImageArray) {
                            
                            if (!assetsImageArray || assetsImageArray.count == 0) {
                                [PubllicMaskViewHelper showTipViewWith:@"未选择车牌" inSuperView:self.view  withDuration:1];
                                return;
                                
                            }
                            UIImage *assetImage = assetsImageArray.firstObject;
                            
                            [self  showWaitingView];
                            [[XYPlateRecognizeUtil new] recognizePateWithImage:assetImage
                                                                      complete:^(NSArray *plateStringArray,int code){
                                                                          [self removeWaitingView];
                                  if(code == 0){
                                    [PubllicMaskViewHelper showTipViewWith:@"未识别到车牌,请调整距离和角度" inSuperView:self.view  withDuration:1];
                                  }else{
                                      NSArray *arr = [[plateStringArray firstObject]componentsSeparatedByString:@":"];
                                      [[NSNotificationCenter defaultCenter]postNotificationName:KEY_AUTO_ADD_CONTACT object:[arr lastObject]];
                                      [self selectWithIndex:1];
                                  }
                                NSLog(@"%@",plateStringArray);
                            }];
                        }];
                        
                    }else if([item.title isEqualToString:@"手动添加客户"])
                    {
                        [self selectWithIndex:1];
                        CustomerViewController *vc2 = (CustomerViewController *)self.viewControllers[1];
                        [vc2 addBtnClicked];
                        
                    }else
                    {
                        [self selectWithIndex:0];
                        NewTipViewController *vc2 = (NewTipViewController *)self.viewControllers[0];
                        [vc2 addBtnClicked];
                    }


                }
            }];
    
}

//生成tabbar子ViewController
- (void)initViewControllers
{
    NewTipViewController *vc1 = [[NewTipViewController alloc]init];
    vc1.m_delegate = self;
    
    CustomerViewController *vc2 = [[CustomerViewController alloc]init];
    vc2.m_delegate = self;
    
    RepairPrintViewController *vc3 = [[RepairPrintViewController alloc]init];
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


@end
