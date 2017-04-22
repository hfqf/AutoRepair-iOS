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
    UITextField *m_input3;
}
@property(nonatomic,strong) NSString *m_startTime;
@property(nonatomic,strong) NSString *m_endTime;
@property(nonatomic,strong) ADTContacterInfo *m_selectContact;
@end

@implementation RepairPrintViewController

- (id)init{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, 210)];

        self.tableView.tableHeaderView = bg;
        
        m_input1 = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, MAIN_WIDTH-40, 40)];
        m_input1.delegate = self;
        [m_input1 setPlaceholder:@"输入查询的开始时间"];
        [m_input1 setTextAlignment:NSTextAlignmentCenter];
        m_input1.layer.cornerRadius = 2;
        m_input1.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input1.layer.borderWidth = 0.5;
        [m_input1 setTextColor:[UIColor blackColor]];
        [m_input1 setFont:[UIFont systemFontOfSize:20]];
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
        [m_input2 setFont:[UIFont systemFontOfSize:20]];
        [m_input2 setBackgroundColor:[UIColor clearColor]];
        [bg addSubview:m_input2];
        [m_input2 setInputView:[self getSelectTimePicker:1]];
        
        m_input3 = [[UITextField alloc]initWithFrame:CGRectMake(20, 110, MAIN_WIDTH-40, 40)];
        m_input3.layer.cornerRadius = 2;
        m_input3.layer.borderColor = PUBLIC_BACKGROUND_COLOR.CGColor;
        m_input3.delegate = self;
        m_input3.layer.borderWidth = 0.5;
        m_input3.returnKeyType = UIReturnKeySearch;
        [m_input3 setPlaceholder:@"点击键盘搜索查单个客户/不填则查所有"];
        [m_input3 setTextAlignment:NSTextAlignmentCenter];
        [m_input3 setTextColor:[UIColor blackColor]];
        [m_input3 setFont:[UIFont systemFontOfSize:14]];
        [m_input3 setBackgroundColor:[UIColor clearColor]];
        [bg addSubview:m_input3];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(20, 160, MAIN_WIDTH-40, 40)];
        btn.layer.cornerRadius =2;
        [btn setBackgroundColor:PUBLIC_BACKGROUND_COLOR];
        [btn setTitle:@"开始搜索维修记录" forState:UIControlStateNormal];
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

- (void)selectContactClicked
{
    self.m_selectContact = nil;
    CustomerViewController *vc = [[CustomerViewController alloc]initForSelectContact:@""];
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
    
    if(m_input3.text.length == 0)
    {
        [m_input3 resignFirstResponder];
    }
    else
    {
        if(m_input3.isEditing)
        {
            [PubllicMaskViewHelper showTipViewWith:@"搜索对象还未选择好" inSuperView:self.view  withDuration:1];
            return;
        }
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
    NSString *urlString= [NSString stringWithFormat:@"%@/repair/print?owner=%@&carcode=%@&start=%@&end=%@",SERVER,[LoginUserUtil userTel],self.m_selectContact ? self.m_selectContact.m_carCode : @"",self.m_startTime,self.m_endTime];
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
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setFrame:CGRectMake(MAIN_WIDTH-60, DISTANCE_TOP, 40, HEIGHT_NAVIGATION)];
    [addBtn setTitle:@"分享" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    [ShareSdkUtil startShare:@"统计" url:m_web.request.URL.absoluteString title:@"统计数据"];
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
    if(textField == m_input3)
    {

//        [self selectContactClicked];
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == m_input3)
    {
        [m_input1 resignFirstResponder];
        [m_input2 resignFirstResponder];
        [m_input3 resignFirstResponder];
        [self selectContactClicked];
        return YES;
    }
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
    [m_input3 setText:contact.m_userName];
}
@end
