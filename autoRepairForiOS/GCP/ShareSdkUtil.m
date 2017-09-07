//
//  ShareSdkUtil.m
//  AutoRepairHelper3
//
//  Created by points on 2017/4/17.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "ShareSdkUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@implementation ShareSdkUtil

+ (BOOL)startShare:(NSString *)content
               url:(NSString *)url
             title:(NSString *)title
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //通用参数设置
    [shareParams SSDKSetupShareParamsByText:content
                                    images:@[[UIImage imageNamed:@"app_icon"]]
                                       url:[NSURL URLWithString:url]
                                     title:title
                                      type:SSDKContentTypeAuto];
    

        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    
    return YES;
}

@end
