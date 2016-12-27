//
//  EGOImageView+SetImage.h
//  xxt_xj
//
//  Created by Points on 14-4-25.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "EGOImageView.h"
@interface EGOImageView(publicSetImage)

- (void)setImageForAllSDK:(NSURL *)url;

- (void)setImageForAllSDK:(NSURL *)url withDefaultImage:(UIImage *)img;

@end
