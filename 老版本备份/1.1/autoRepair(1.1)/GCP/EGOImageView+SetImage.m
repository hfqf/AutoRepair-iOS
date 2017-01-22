//
//  EGOImageView+SetImage.m
//  xxt_xj
//
//  Created by Points on 14-4-25.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "EGOImageView+SetImage.h"
#import "UIImageView+AFNetworking.h"

@interface EGOImageView()<EGOImageViewDelegate>

@end

@implementation EGOImageView(publicSetImage)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setImageForAllSDK:(NSURL *)url
{
//   if(OS_ABOVE_IOS6)
//    {
//        [self setImageWithURL:url placeholderImage:KEY_DEFAULT_CONTENT_IAMGE];
//    }
//    else
//    {
        self.placeholderImage = KEY_DEFAULT_CONTENT_IAMGE;
        [self setImageURL:url];
   // }
}

- (void)setImageForAllSDK:(NSURL *)url withDefaultImage:(UIImage *)img
{
        self.placeholderImage = img;
        [self setImageURL:url];
   //}
}

@end
