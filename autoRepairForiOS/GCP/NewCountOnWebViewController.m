//
//  NewCountOnWebViewController.m
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/27.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "NewCountOnWebViewController.h"
#import "CustomerViewController.h"
#import "AppDelegate.h"
@interface NewCountOnWebViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIWebView *m_web;
    UITextField *m_input1;
    UITextField *m_input2;
    UIButton *btn;
}
@property(nonatomic,strong) NSString *m_startTime;
@property(nonatomic,strong) NSString *m_endTime;
@property(assign)NSInteger  m_type;
@end

@implementation NewCountOnWebViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self forceOrientationPortrait];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self forceOrientationLandscapeLeft];

}

- (void)backBtnClicked
{
    XTNavigationController *navi = (XTNavigationController *)self.navigationController;
    if(navi.interfaceOrientation ==  UIInterfaceOrientationLandscapeLeft)
    {
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [self forceOrientationPortrait];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (id)initWith:(NSInteger)type{
    self.m_type = type;
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, 70)];

        self.tableView.tableHeaderView = bg;
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(5,5, (MAIN_WIDTH-20)/2, 30)];
        m_input1.delegate = self;
        [m_input1 setPlaceholder:@"输入查询的开始时间"];
        NSString *now = [LocalTimeUtil getLocalTimeWith:[NSDate date]];
        [m_input1 setText:[NSString stringWithFormat:@"%@-01",[now  substringToIndex:7]]];
        self.m_startTime = m_input1.text;
        [m_input1 setTextAlignment:NSTextAlignmentCenter];
        m_input1.layer.cornerRadius = 2;
        m_input1.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input1.layer.borderWidth = 0.5;
        [m_input1 setTextColor:[UIColor blackColor]];
        [m_input1 setFont:[UIFont systemFontOfSize:14]];
        [m_input1 setBackgroundColor:[UIColor clearColor]];
        [bg addSubview:m_input1];
        [m_input1 setInputView:[self getSelectTimePicker:0]];

        m_input2 = [[UITextField alloc]initWithFrame:CGRectMake((MAIN_WIDTH-20)/2+15,5, (MAIN_WIDTH-20)/2, 30)];
        m_input2.delegate = self;
        m_input2.layer.cornerRadius = 2;
        m_input2.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input2.layer.borderWidth = 0.5;
        [m_input2 setPlaceholder:@"输入查询的结束时间"];
        [m_input2 setText:[NSString stringWithFormat:@"%@",[LocalTimeUtil getLocalTimeWith:[NSDate date]]]];
        self.m_endTime = m_input2.text;
        [m_input2 setTextAlignment:NSTextAlignmentCenter];
        [m_input2 setTextColor:[UIColor blackColor]];
        [m_input2 setFont:[UIFont systemFontOfSize:14]];
        [m_input2 setBackgroundColor:[UIColor clearColor]];
        [bg addSubview:m_input2];
        [m_input2 setInputView:[self getSelectTimePicker:1]];

        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(5,CGRectGetMaxY(m_input2.frame)+5, MAIN_WIDTH-10, 30)];
        btn.layer.cornerRadius =2;
        [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
        [btn setTitle:@"开始查询" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [bg addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];

        m_web = [[UIWebView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT*2)];
        m_web.delegate = self;
        m_web.scalesPageToFit = YES;
        self.tableView.tableFooterView = m_web;
    }
    return self;
}


- (void)btnClicked
{
    if(self.m_startTime.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }

    if(self.m_endTime.length == 0)
    {
        [PubllicMaskViewHelper showTipViewWith:@"开始时间不能为空" inSuperView:self.view  withDuration:1];
        return;
    }

    [self refreshWebView];
}

- (void)requestData:(BOOL)isRefresh
{
    [self refreshWebView];
    self.m_arrData = @[@""];
    [self reloadDeals];
}

- (void)refreshWebView
{
    NSString *urlString = nil;
    if(self.m_type == 0){
      urlString  = [NSString stringWithFormat:@"%@/repairstatistics/customser?start=%@&end=%@&owner=%@",SERVER,self.m_startTime,self.m_endTime,[LoginUserUtil userTel]];
    }else if (self.m_type == 1){
        urlString  = [NSString stringWithFormat:@"%@/repairstatistics/newrepair?start=%@&end=%@&owner=%@",SERVER,self.m_startTime,self.m_endTime,[LoginUserUtil userTel]];
    }else if (self.m_type == 2){
        urlString  = [NSString stringWithFormat:@"%@/repairstatistics/saledgoods?start=%@&end=%@&owner=%@",SERVER,self.m_startTime,self.m_endTime,[LoginUserUtil userTel]];
    }else if (self.m_type == 10){
        urlString  = [NSString stringWithFormat:@"%@/repairstatistics/in?start=%@&end=%@&owner=%@",SERVER,self.m_startTime,self.m_endTime,[LoginUserUtil userTel]];
    }else if (self.m_type == 11){
        urlString  = [NSString stringWithFormat:@"%@/repairstatistics/out?start=%@&end=%@&owner=%@",SERVER,self.m_startTime,self.m_endTime,[LoginUserUtil userTel]];
    }else if (self.m_type == 12){
        urlString  = [NSString stringWithFormat:@"%@/repairstatistics/own?start=%@&end=%@&owner=%@",SERVER,self.m_startTime,self.m_endTime,[LoginUserUtil userTel]];
    }

    // 将地址编码
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 60];
    [request setHTTPMethod:@"GET"];
    [m_web loadRequest:request];
}

- (UIView *)getSelectTimePicker:(NSInteger)tag
{
    UIView *inputBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 200)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(10, 10, 40, 30)];
    [cancelBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    [inputBg addSubview:cancelBtn];
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn setFrame:CGRectMake(MAIN_WIDTH-60, 10, 40, 30)];
    [confirmBtn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
    [inputBg addSubview:confirmBtn];
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, MAIN_WIDTH, 140)];
    picker.tag = tag;
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [inputBg addSubview:picker];
    return inputBg;
}

- (void)cancelBtnClicked:(UITextField *)input
{
    [m_input1 resignFirstResponder];
    [m_input2 resignFirstResponder];
    [self reloadDeals];
}

- (void)confirmBtnClicked:(UITextField *)input
{
    [m_input1 resignFirstResponder];
    [m_input2 resignFirstResponder];
    UIView *bg = input.superview;

    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith3:[picker date]];
            if(picker.tag  == 0)
            {
                self.m_startTime = [time substringToIndex:10];
                [m_input1 setText:self.m_startTime];
            }
            else if (picker.tag == 1)
            {
                if(![LocalTimeUtil isValid2:self.m_startTime endTime:time])
                {
                    [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于或等于开始时间" inSuperView:self.tableView withDuration:1];
                }
                else
                {
                    self.m_endTime = [time substringToIndex:10];
                    [m_input2 setText:self.m_endTime];
                }
            }
            else
            {

            }
        }
    }


}


- (void)viewDidLoad {
    [super viewDidLoad];
    [title setText:@"统计"];
    [backBtn setTitle:@"竖屏" forState:UIControlStateNormal];

//    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [addBtn setFrame:CGRectMake(MAIN_WIDTH-HEIGHT_NAVIGATION, DISTANCE_TOP, HEIGHT_NAVIGATION, HEIGHT_NAVIGATION)];
////     [addBtn setTitle:@"" forState:UIControlStateNormal];
////    [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
//    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
//    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"复制分享当前统计数据的网址,可通过电脑打印",@"直接打印", nil];
    act.tag = 1000;
    [act showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_input1 resignFirstResponder];
    [m_input2 resignFirstResponder];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [self showWaitingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeWaitingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeWaitingView];
}



- (void)forceOrientationLandscapeLeft
{

    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    appdelegate.isAllowRotation = YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:[UIApplication sharedApplication].keyWindow
     ];

    XTNavigationController *navi = (XTNavigationController *)self.navigationController;

    navi.interfaceOrientation = UIInterfaceOrientationLandscapeLeft;

    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscape;

    //设置屏幕的转向为横屏

    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];

    //刷新

    [UIViewController attemptRotationToDeviceOrientation];

}

- (void)forceOrientationPortrait

{

    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    appdelegate.isAllowRotation = NO;

    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:[UIApplication sharedApplication].keyWindow
     ];

    XTNavigationController *navi = (XTNavigationController *)self.navigationController;

    navi.interfaceOrientation = UIInterfaceOrientationPortrait;

    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;

    //设置屏幕的转向为竖屏

    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];

    //刷新

    [UIViewController attemptRotationToDeviceOrientation];

}

- (void)setFrame:(CGRect)frame
{
    navigationBG.frame = CGRectMake(0,0, frame.size.width,64);
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFrame:CGRectMake(70,( (HEIGHT_NAVIGATION -20) -34)/ 2  + 20, MAIN_WIDTH-140, 34)];

    [backBtn setFrame:CGRectMake(5,20, 45,44)];
    self.tableView.frame = CGRectMake(0,CGRectGetMaxY(navigationBG.frame), frame.size.width, frame.size.height-CGRectGetMaxY(navigationBG.frame));

    m_input1.frame = CGRectMake(5,5, (MAIN_WIDTH-20)/2, 30);
    m_input2.frame =CGRectMake((MAIN_WIDTH-20)/2+15,5, (MAIN_WIDTH-20)/2, 30);
    [btn setFrame:CGRectMake(5,CGRectGetMaxY(m_input2.frame)+5, MAIN_WIDTH-10, 30)];
}


@end

