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
@interface SettingViewController()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>

@end
@implementation SettingViewController


- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain withIsNeedPullDown:YES withIsNeedPullUpLoadMore:NO withIsNeedBottobBar:YES];
    if (self)
    {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView.backgroundView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setBackgroundColor:UIColorFromRGB(0XEBEBEB)];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    backBtn.hidden = YES;
    [title setText:@"设置"];
    
   

}

- (void)requestData:(BOOL)isRefresh
{
    self.m_arrData = @[
                       @"客户资料备份"
                       ];
    [self reloadDeals];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.m_arrData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"spe";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setText:[self.m_arrData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sendMailInApp];
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


@end
