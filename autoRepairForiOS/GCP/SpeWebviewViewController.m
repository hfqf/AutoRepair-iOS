//
//  SpeWebviewViewController.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/12.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "SpeWebviewViewController.h"

@interface SpeWebviewViewController ()<UIWebViewDelegate,UIActionSheetDelegate>{
    UIWebView *m_web;
    BOOL m_isShow;
}

@property(nonatomic,strong)NSString *m_url;
@property(nonatomic,strong)NSString *m_title;

@end

@implementation SpeWebviewViewController

- (id)initWithUrl:(NSString *)url withTitle:(NSString *)_title
{
    self.m_url = url;
    self.m_title = _title;
    if(self = [super init]){
      
    }
    return self;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_web = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBG.frame), MAIN_WIDTH, MAIN_HEIGHT-CGRectGetMaxY(navigationBG.frame))];
    m_web.delegate = self;
    [self.view addSubview:m_web];
    [m_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.m_url]]];
    [title setText:self.m_title];

        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(MAIN_WIDTH-50, DISTANCE_TOP, 44, 44)];
    //     [addBtn setTitle:@"" forSt ate:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"moresetting"] forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [addBtn setTitleColor:KEY_COMMON_GRAY_CORLOR forState:UIControlStateNormal];
        [navigationBG addSubview:addBtn];
}

- (void)addBtnClicked
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"屏幕截图",@"复制分享当前统计数据的网址,可通过电脑打印",nil];
    act.tag = 1000;
    [act showInView:self.view];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){

        UIGraphicsBeginImageContextWithOptions(MAIN_FRAME.size, NO, [[UIScreen mainScreen] scale]);
        [self.view drawViewHierarchyInRect:CGRectMake(0, HEIGHT_NAVIGATION, MAIN_WIDTH, MAIN_HEIGHT-HEIGHT_NAVIGATION) afterScreenUpdates:NO];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [self loadImageFinished:snapshot];

    }else if(buttonIndex == 1){
        [ShareSdkUtil startShare:@"工单明细" url:self.m_url title:@"工单明细"];
    }else{

    }
}


- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

    [PubllicMaskViewHelper showTipViewWith:@"保存成功,请到相册去查看" inSuperView:self.view  withDuration:1];
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

@end
