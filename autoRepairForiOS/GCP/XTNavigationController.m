//
//  XTNavigationController.m
//  JZH_Test
//
//  Created by Points on 13-10-11.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import "XTNavigationController.h"
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

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return NO;
}


@end
