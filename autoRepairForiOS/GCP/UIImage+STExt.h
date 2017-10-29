//
//  UIImage+STExt.h
//  MOS
//
//  Created by yls on 14-9-5.
//  Copyright (c) 2014年 SiTE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (STExt)

+ (UIImage *)imageWithCGSize:(CGSize)size color:(UIColor *)color;
+ (UIImage *)imageWithCGSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius;

- (CGSize)imageConstrainedToSize:(CGSize)size;
- (CGSize)resizeToSize:(CGSize)maxSize;

@end
