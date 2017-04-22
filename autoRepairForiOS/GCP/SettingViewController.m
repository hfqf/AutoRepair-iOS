//
//  SettingViewController.m
//  AutoRepairHelper
//
//  Created by Points on 15-4-28.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "SettingViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "SpeSqliteUpdateManager.h"
#import "EditUserViewController.h"
@interface SettingViewController()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIWebView *web;
}

@property (assign) NSInteger m_totalPrice;
@property (assign) NSInteger m_totalCount;

@end
@implementation SettingViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:NO withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        web= [[UIWebView alloc]initWithFrame:CGRectMake(0,40, MAIN_WIDTH,150)];
        [web setBackgroundColor:[UIColor clearColor]];
        [web.scrollView setBackgroundColor:[UIColor clearColor]];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/noticeboard/ios",SERVER]]]];
        web.scrollView.scrollEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    backBtn.hidden = YES;
    [title setText:@"我的"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData:YES];
}

#define INFO_HIGH 300

- (UIView *)createHeadView
{
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, INFO_HIGH)];
    [bg setBackgroundColor:[UIColor clearColor]];
    ClassIconImageView *head = [[ClassIconImageView alloc]initWithFrame:CGRectMake((MAIN_WIDTH-100)/2, 30, 100,100)];
    head.userInteractionEnabled = YES;
    head.clipsToBounds = YES;
    [head  setNewImage:[NSURL URLWithString:[LoginUserUtil headUrl]] WithSpeWith:1 withDefaultImg:@"ic_tabbar_compose_icon_add_highlighted"];
    [bg addSubview:head];
    
    UITapGestureRecognizer *updateHeadGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateHead)];
    [head addGestureRecognizer:updateHeadGest];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(head.frame)+30, MAIN_WIDTH, 30)];
    [name setTextAlignment:NSTextAlignmentCenter];
    [name setTextColor:PUBLIC_BACKGROUND_COLOR];
    [name setFont:[UIFont boldSystemFontOfSize:30]];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setText:[LoginUserUtil userName]];
    [bg addSubview:name];
    
    
    UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(name.frame)+20, MAIN_WIDTH, 20)];
    [price setTextAlignment:NSTextAlignmentCenter];
    [price setTextColor:PUBLIC_BACKGROUND_COLOR];
    [price setFont:[UIFont boldSystemFontOfSize:20]];
    [price setBackgroundColor:[UIColor clearColor]];
    [price setText:[NSString stringWithFormat:@"今天收入: %ld元",(long)self.m_totalPrice]];
    [bg addSubview:price];
    
    UILabel *count = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(price.frame)+20, MAIN_WIDTH, 20)];
    [count setTextAlignment:NSTextAlignmentCenter];
    [count setTextColor:PUBLIC_BACKGROUND_COLOR];
    [count setFont:[UIFont boldSystemFontOfSize:20]];
    [count setBackgroundColor:[UIColor clearColor]];
    [count setText:[NSString stringWithFormat:@"今天维修: %ld次",(long)self.m_totalCount]];
    [bg addSubview:count];
    return bg;
    
}

- (void)updateHead
{
    UIActionSheet *act = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库", nil];
    [act showInView:self.view];
}



- (void)requestData:(BOOL)isRefresh
{
    self.m_arrData = @[
                       @"个人资料",
                       @"最新公告",
                       @"换肤",
                       @"分享app给好友",
                       @"去AppStore评论",
                       @"修改密码",
                       @"退出"
                       ];
    [self reloadDeals];
    
    [HTTP_MANAGER queryTodayBills:^(NSDictionary *succeedResult) {
        if([succeedResult[@"code"]integerValue] == 1)
        {
            self.m_totalCount = [succeedResult[@"ret"][@"totalRepCount"]integerValue];
            self.m_totalPrice = [succeedResult[@"ret"][@"totalprice"]integerValue];
        }
        else
        {
            
        }
        
        [self reloadDeals];
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return INFO_HIGH;
    }

    if(indexPath.section == 1)
    {
        return 200;
    }
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.m_arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setBackgroundColor:UIColorFromRGB(0xFAFAFA)];

    if(indexPath.section == 0)
    {
        
        [cell addSubview:[self createHeadView]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10, 10, 220, 20)];
        [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
        [_tit setFont:[UIFont systemFontOfSize:16]];
        [_tit setText:[self.m_arrData objectAtIndex:indexPath.section]];
        [cell addSubview:_tit];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, INFO_HIGH-0.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
        [cell addSubview:sep];
    }
    else if(indexPath.section == 1)
    {
        UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10, 10, 200, 20)];
        [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
        [_tit setFont:[UIFont systemFontOfSize:16]];
        [_tit setText:[self.m_arrData objectAtIndex:indexPath.section]];
        [cell addSubview:_tit];
        
     
        [cell addSubview:web];
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 199.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
        [cell addSubview:sep];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *_tit = [[UILabel alloc]initWithFrame:CGRectMake( 10, 30, 200, 20)];
        [_tit setTextColor:UIColorFromRGB(0x4D4D4D)];
        [_tit setFont:[UIFont systemFontOfSize:16]];
        [_tit setText:[self.m_arrData objectAtIndex:indexPath.section]];
        [cell addSubview:_tit];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(00, 79.5, MAIN_WIDTH, 0.5)];
        [sep setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
        [cell addSubview:sep];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        EditUserViewController *vc= [[EditUserViewController alloc]init];
        vc.m_delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 1)
    {
        
    }
    else if (indexPath.section == 2)
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"ChangeSkinViewController") alloc]init] animated:YES];
    }
    else if (indexPath.section == 3)
    {
        [ShareSdkUtil startShare:@"汽修小助手是为个人和中小型汽车修理厂商提供一个管理客户及修理记录的工具。" url:@"https://itunes.apple.com/cn/app/%E6%B1%BD%E4%BF%AE%E5%B0%8F%E5%8A%A9%E6%89%8B/id1106728499?mt=8" title:@"分享汽修小助手"];
    }
    else if (indexPath.section == 4)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%B1%BD%E4%BF%AE%E5%B0%8F%E5%8A%A9%E6%89%8B/id1106728499?mt=8"]];
    }
    else if (indexPath.section == 5)
    {
        [self.navigationController pushViewController:[[NSClassFromString(@"ResetPwdViewController") alloc]init] animated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 上传本地log文件


- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [PubllicMaskViewHelper showTipViewWith:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替" inSuperView:self.view  withDuration:1];
        return;
    }
    if (![mailClass canSendMail]) {
        [PubllicMaskViewHelper showTipViewWith:@"用户没有设置邮件账户" inSuperView:self.view  withDuration:1];
        return;
    }
    [self displayMailPicker];
}


//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"客户资料备份上传"];
    
    NSString *fullPath = [[SpeSqliteUpdateManager sharedInstance] pathLocalDB];
    
    NSData *fileData = [NSData dataWithContentsOfFile:fullPath];
    [mailPicker addAttachmentData: fileData mimeType: @"" fileName:@"客户资料"];

    [self presentViewController:mailPicker animated:YES completion:NULL];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            //关闭邮件发送窗口
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            //关闭邮件发送窗口
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            break;
        case MFMailComposeResultSent:
            msg = @"邮件已发送";
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [PubllicMaskViewHelper showTipViewWith:msg inSuperView:self.view  withDuration:1];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [LocalImageHelper selectPhotoFromCamera:self];
    }else if (buttonIndex == 1)
    {
        [LocalImageHelper selectPhotoFromLibray:self];
    }
    else
    {
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    [self showWaitingView];
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:NO completion:NULL];
    NSString *path = [LocalImageHelper saveImage:image];
    
    NSString *fileName = [LocalTimeUtil getCurrentTime2];
    [HTTP_MANAGER uploadBOSFile:path
                   withFileName: fileName
                 successedBlock:^(NSDictionary *succeedResult) {
                     
                     if([succeedResult[@"code"]integerValue] == 1)
                     {
                         NSString *newHead = succeedResult[@"url"];
                         [HTTP_MANAGER updateHead:newHead
                                   successedBlock:^(NSDictionary *succeedResult) {
                             [self removeWaitingView];
                             if([succeedResult[@"code"]integerValue] == 1)
                             {
                                 [[NSUserDefaults standardUserDefaults]setObject:newHead forKey:KEY_AUTO_HEAD];
                                 [PubllicMaskViewHelper showTipViewWith:@"更新成功" inSuperView:self.view  withDuration:1];
                                 [[EGOCache globalCache]clearCache];
                                 [self reloadDeals];
                             }
                             else
                             {
                                 [self removeWaitingView];
                                 [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view  withDuration:1];
                             }
                           
                             
                         } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
                             [self removeWaitingView];
                             [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view  withDuration:1];
                         }];
        
                     }
                     else
                     {
                         [self removeWaitingView];
                         [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view  withDuration:1];
                     }
        
    } failedBolck:^(AFHTTPRequestOperation *response, NSError *error) {
        
        [self removeWaitingView];
        [PubllicMaskViewHelper showTipViewWith:@"更新失败" inSuperView:self.view  withDuration:1];

    }];
    
}

- (void)onRefreshParentData
{
    [self requestData:YES];
}
@end
