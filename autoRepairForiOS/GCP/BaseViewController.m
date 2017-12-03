//
//  BaseViewController.m
//  xxt_xj
//
//  Created by Points on 13-11-25.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "BaseViewController.h"
#import "JHUD.h"
@interface BaseViewController ()
{
    UIImageView *_arrowDownImageView;   ///< 下拉菜单箭头
    NSArray *_pullDownMenuItems;    ///< 下拉菜单选项
    
    JHUD   *hudView;
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    navigationBG = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, MAIN_WIDTH, HEIGHT_NAVIGATION)];
    navigationBG.userInteractionEnabled = YES;
    [navigationBG setBackgroundColor:UIColorFromRGB(0Xf6f6f6)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navigationBG];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0,DISTANCE_TOP,61,44)];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:UIColorFromRGB(0x787878) forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [navigationBG addSubview:backBtn];
    
    title= [[UILabel alloc]initWithFrame:CGRectMake(50,DISTANCE_TOP+7,MAIN_WIDTH-100, 30)];
    [title setFont:[UIFont systemFontOfSize:19]];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setText:self.title];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:UIColorFromRGB(0x787878)];
    [navigationBG addSubview:title];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
    hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    [hudView setBackgroundColor:[UIColor clearColor]];
    hudView.messageLabel.text = @"加载中...";
    
    [hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
    [hudView hideAfterDelay:5];
}

- (void)showWaitingViewWith:(int)delay
{
    hudView = [[JHUD alloc]initWithFrame:self.view.bounds];
    
    hudView.messageLabel.text = @"加载中...";
    
    [hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
}

- (void)removeWaitingView
{
    [hudView hide];
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSInteger left = MAIN_HEIGHT-m_currentInputY;
    
    if(left >(int)kbSize.height+44)  //44是选择文字区域
    {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0,-kbSize.height, MAIN_WIDTH,MAIN_HEIGHT-kbSize.height)];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
    [self.view setFrame:CGRectMake(0,0 , MAIN_WIDTH,MAIN_HEIGHT)];
    }];
}
@end
