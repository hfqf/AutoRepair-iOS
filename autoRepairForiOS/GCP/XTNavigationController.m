//
//  XTNavigationController.m
//  JZH_Test
//
//  Created by Points on 13-10-11.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "XTNavigationController.h"
#import "NewCountOnWebViewController.h"
@interface XTNavigationController ()

@end

@implementation XTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0x1488DC)];
    if (OS_ABOVE_IOS7)
    {
        self.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
 
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //PUBLIC_RELEASE(m_navigationBar);
}

- (BOOL)shouldAutorotate
{
//    NSArray *arr = self.viewControllers;
//    for(UIViewController *vc in arr){
//       if ([vc isKindOfClass:NSClassFromString(@"NewCountOnWebViewController")]) {
//           NewCountOnWebViewController *New = (NewCountOnWebViewController *)vc;
//           [New setFrame:self.view.frame];
//           return YES;
//       }
//    }
    return YES;
}
//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.interfaceOrientationMask == 0 ? UIInterfaceOrientationMaskAll : self.interfaceOrientationMask;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.interfaceOrientation;
}


@end
