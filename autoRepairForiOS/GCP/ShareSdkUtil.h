//
//  ShareSdkUtil.h
//  AutoRepairHelper3
//
//  Created by points on 2017/4/17.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSdkUtil : NSObject

+ (BOOL)startShare:(NSString *)content
               url:(NSString *)url
             title:(NSString *)title;
@end
