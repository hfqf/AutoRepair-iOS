//
//  RepairPrintViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/11.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "RepairPrintViewController.h"
#import "CustomerViewController.h"
@interface RepairPrintViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomerViewControllerDelegate>
{
    UIWebView *m_web;
    UITextField *m_input1;
    UITextField *m_input2;
    UIButton *m_input3;
}
@property(nonatomic,strong) NSString *m_startTime;
@property(nonatomic,strong) NSString *m_endTime;
@property(nonatomic,strong) ADTContacterInfo *m_selectContact;
@end

@implementation RepairPrintViewController

- (id)init{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:NO];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, 210)];
        [self.view addSubview:bg];
        [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(bg.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(bg.frame)-HEIGHT_MAIN_BOTTOM)];
        
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, MAIN_WIDTH-40, 40)];
        m_input1.delegate = self;
        [m_input1 setPlaceholder:@"输入查询的开始时间"];
        [m_input1 setTextAlignment:NSTextAlignmentCenter];
        m_input1.layer.cornerRadius = 2;
        m_input1.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input1.layer.borderWidth = 0.5;
        [m_input1 setTextColor:[UIColor blackColor]];
        [m_input1 setFont:[UIFont systemFontOfSize:14]];
        [m_input1 setBackgroundColor:[UIColor clearColor]];
        [bg addSubview:m_input1];
        [m_input1 setInputView:[self getSelectTimePicker:0]];
        
        m_input2 = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, MAIN_WIDTH-40, 40)];
        m_input2.delegate = self;
        m_input2.layer.cornerRadius = 2;
        m_input2.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input2.layer.borderWidth = 0.5;
        [m_input2 setPlaceholder:@"输入查询的结束时间"];
        [m_input2 setTextAlignment:NSTextAlignmentCenter];
        [m_input2 setTextColor:[UIColor blackColor]];
        [m_input2 setFont:[UIFont systemFontOfSize:14]];
        [m_input2 setBackgroundColor:[UIColor clearColor]];
        [bg addSubview:m_input2];
        [m_input2 setInputView:[self getSelectTimePicker:1]];
        
        m_input3 = [UIButton buttonWithType:UIButtonTypeCustom];
        m_input3.frame =  CGRectMake(20, 110, MAIN_WIDTH-40, 40);
        m_input3.layer.cornerRadius = 2;
        m_input3.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input3.layer.borderWidth = 0.5;
        [m_input3 setTitle:@"点击选择客户" forState:UIControlStateNormal];
        [m_input3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_input3.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [m_input3 setBackgroundColor:[UIColor clearColor]];
        [m_input3 addTarget:self action:@selector(selectContactClicked) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:m_input3];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, 160, MAIN_WIDTH-40, 40)];
        btn.layer.cornerRadius =2;
        [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
        [btn setTitle:@"开始搜索" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [bg addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        m_web = [[UIWebView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame))];
        m_web.delegate = self;
        m_web.scalesPageToFit = YES;
        self.tableView.tableHeaderView = m_web;
    }
    return self;
}

- (void)selectContactClicked
{
    CustomerViewController *vc = [[CustomerViewController alloc]initForAddRepair];
    vc.m_selectDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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
    
    if(self.m_selectContact == nil)
    {
        [PubllicMaskViewHelper showTipViewWith:@"客户不能为空" inSuperView:self.view  withDuration:1];
        return;
    }
    [self refreshWebView];
}

- (void)requestData:(BOOL)isRefresh
{
    [self refreshWebView];
    [self reloadDeals];
}

- (void)refreshWebView
{
    NSString *urlString= [NSString stringWithFormat:@"%@/repair/print?carcode=%@&start=%@&end=%@",SERVER,self.m_selectContact.m_carCode,self.m_startTime,self.m_endTime];
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
    [m_input3 resignFirstResponder];
    [self reloadDeals];
}

- (void)confirmBtnClicked:(UITextField *)input
{
    [m_input1 resignFirstResponder];
    [m_input2 resignFirstResponder];
    [m_input3 resignFirstResponder];
    UIView *bg = input.superview;
    
    for(UIView *vi in bg.subviews)
    {
        if([vi isKindOfClass:[UIDatePicker class]])
        {
            UIDatePicker *picker = (UIDatePicker *)vi;
            NSString *time = [LocalTimeUtil getLocalTimeWith3:[picker date]];
            if(picker.tag  == 0)
            {
                self.m_startTime = time;
                [m_input1 setText:time];
            }
            else if (picker.tag == 1)
            {
                if(![LocalTimeUtil isValid2:self.m_startTime endTime:time])
                {
                    [PubllicMaskViewHelper showTipViewWith:@"结束时间不能早于或等于开始时间" inSuperView:self.tableView withDuration:1];
                }
                else
                {
                    self.m_endTime = time;
                    [m_input2 setText:time];
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
    backBtn.hidden = YES;
    [title setText:@"统计"];
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


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showWaitingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeWaitingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeWaitingView];
}

#pragma mark - CustomerViewControllerDelegate

- (void)onSelectContact:(ADTContacterInfo *)contact
{
    self.m_selectContact = contact;
    [m_input3 setTitle:contact.m_userName forState:UIControlStateNormal];
}
@end
