//
//  BaseViewController.m
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()
{
    UIImageView *_arrowDownImageView;   ///< 下拉菜单箭头
    NSArray *_pullDownMenuItems;    ///< 下拉菜单选项
}

@property (nonatomic, assign) BOOL showNavigationArrowFlag; ///< 是否显示下拉箭头，默认隐藏
@property (nonatomic, assign) BOOL  navigationArrowDownStatus;   ///< 下拉箭头方向，默认down

@end

@implementation BaseViewController

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SpeLog(@"%@---->frame=%@",NSStringFromClass([self class]),NSStringFromCGRect(self.view.frame));
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    _navigationArrowDownStatus = YES;
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    if(OS_ABOVE_IOS7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    navigationBG = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, MAIN_WIDTH, HEIGHT_NAVIGATION+DISTANCE_TOP)];
    navigationBG.userInteractionEnabled = YES;
    [navigationBG setBackgroundColor:KEY_COMMON_CORLOR];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationBG];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0,DISTANCE_TOP,61,44)];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [navigationBG addSubview:backBtn];
    
    title= [[UILabel alloc]initWithFrame:CGRectMake(100, DISTANCE_TOP+5, 120, 34)];
    [title setFrame:CGRectMake(20,5,MAIN_WIDTH-40, title.frame.size.height)];
    title.center = CGPointMake(MAIN_WIDTH/2.0, OS_ABOVE_IOS7?(HEIGHT_STATUSBAR+HEIGHT_NAVIGATION/2.0):HEIGHT_NAVIGATION/2.0);
    [title setFont:[UIFont boldSystemFontOfSize:19]];
    [title setBackgroundColor:[UIColor clearColor]];
    title.hidden = NO;
    [title setText:self.title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)resetBackBtnImage;
{
    [backBtn setBackgroundImage:[UIImage imageNamed:@"topbar_back_un@2x"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"topbar_back_on@2x"] forState:UIControlStateHighlighted];
}

- (void)setBackBtnHomeImage;
{
    [backBtn setBackgroundImage:[UIImage imageNamed:@"common_home"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"common_home_down"] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    SpeLog(@"%@  ======  didReceiveMemoryWarning",NSStringFromClass([self class]));
}

#pragma mark -BaseViewControllerDelegate

- (void)initView
{
    
}

- (void)initData
{
    
}

- (void)backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)showWaitingViewWith:(int)delay
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
    [hud hide:YES afterDelay:delay];
}

- (void)removeWaitingView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)handleError:(NSString*)error
{
    [PubllicMaskViewHelper showTipViewWith:error inSuperView:self.view withDuration:1];
}

- (void)removeBackBtn
{
    backBtn.hidden = YES;
}

- (void)setSliderBtn
{
    [backBtn setFrame:CGRectMake(20,7+DISTANCE_TOP,32,30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"showSlider_un@2x"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"showSlider_on@2x"] forState:UIControlStateHighlighted];
    
}

- (void)sliderBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.m_delegate onShowSliderView];
}



#pragma mark - Private

//右滑
- (void)SwipeToSliderView
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onBackAnaShowSliderView)])
    {
        [self.m_delegate onBackAnaShowSliderView];
    }
}


#pragma mark -  甩屏

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return  UIInterfaceOrientationPortrait |
    UIInterfaceOrientationPortraitUpsideDown |
    UIInterfaceOrientationLandscapeLeft   |
    UIInterfaceOrientationLandscapeRight;
    
}
@end
