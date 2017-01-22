//
//  TabbarBaseViewController.m
//  xxt_xj
//
//  Created by Points on 14-1-8.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "TabbarBaseViewController.h"

@interface TabbarBaseViewController ()
@property(assign)BOOL m_isNeedBottm;

@end

@implementation TabbarBaseViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.m_isNeedBottm = NO;
    }
    return self;
}
- (id)initWith:(BOOL)isNeedBottom
{
    self = [super init];
    if (self) {
        self.m_isNeedBottm = isNeedBottom;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
	m_bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, DISTANCE_TOP+HEIGHT_NAVIGATION, MAIN_WIDTH, MAIN_HEIGHT-(DISTANCE_TOP+HEIGHT_NAVIGATION)-(self.m_isNeedBottm?49:0))];
    m_bgView.userInteractionEnabled = YES;
    [m_bgView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:m_bgView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
