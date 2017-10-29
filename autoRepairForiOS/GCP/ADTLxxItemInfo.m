//
//  ADTLxxItemInfo.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/6.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "ADTLxxItemInfo.h"

@implementation ADTLxxItemInfo
+(ADTLxxItemInfo *)from:(NSDictionary *)info
{
    ADTLxxItemInfo *ret = [[ADTLxxItemInfo alloc]init];
    ret.m_id = [info stringWithFilted:@"_id"];
    ret.m_createTime = [info stringWithFilted:@"inserttime"];
    ret.m_content = [info stringWithFilted:@"content"];

    NSMutableArray *arrPic = [NSMutableArray array];
    for(NSString *url in  [info[@"imageurl"] componentsSeparatedByString:@","]){
        if(url.length >0){
            [arrPic addObject:url];
        }
    }
    ret.m_arrPics = arrPic;
    ret.m_userAvatar = [info stringWithFilted:@"avatar"];
    ret.m_userId = [info stringWithFilted:@"senderid"];
    ret.m_userName = [info stringWithFilted:@"sendername"];
    ret.m_arrComments = info[@"bbslistcomment"];
    ret.m_commentCount =  [NSString stringWithFormat:@"%lu",ret.m_arrComments.count];
    NSMutableArray *arr = [NSMutableArray array];
    for(NSDictionary *comment in ret.m_arrComments){
        [arr addObject:comment[@"_id"]];
    }
    ret.m_arrRefs = arr;
    return ret;
}
@end
