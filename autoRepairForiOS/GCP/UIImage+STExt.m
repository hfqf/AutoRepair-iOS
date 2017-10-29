//
//  UIImage+STExt.m
//  MOS
//
//  Created by yls on 14-9-5.
//  Copyright (c) 2014年 SiTE. All rights reserved.
//

#import "UIImage+STExt.h"

@implementation UIImage (STExt)

+ (UIImage *)imageWithCGSize:(CGSize)size color:(UIColor *)color
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, bitsPerComponent, 0, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    UIGraphicsPushContext(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsBeginImageContext(size);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGImageRef ref = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:ref];
    
    UIGraphicsEndImageContext();
    UIGraphicsPopContext();
    CGContextRelease(context);
    
    return image;
}

+ (UIImage *)imageWithCGSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius
{
    UIImage *image = [self imageWithCGSize:size color:color];
    return [self createRoundedRectImage:image size:size radius:radius];
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

- (CGSize)imageConstrainedToSize:(CGSize)maxSize;
{
    CGSize size = self.size;
    
    if (size.height <= maxSize.height && size.width <= maxSize.width) {
        return size;
    }
    
    CGSize fitSize = size;
    CGFloat rate = size.width/size.height;

    if (fitSize.height > maxSize.height) {
        fitSize.height = maxSize.height;
        fitSize.width = fitSize.height*rate;
    }
    
    if (fitSize.width > maxSize.width) {
        fitSize.width = maxSize.width;
        fitSize.height = fitSize.width/rate;
    }
    
    return fitSize;
}

- (CGSize)resizeToSize:(CGSize)maxSize;
{
    CGSize size = self.size;
    CGSize fitSize = size;
    
    CGFloat rate = size.width/size.height;
    CGFloat torate = maxSize.width/maxSize.height;
    CGFloat wrate = maxSize.width/size.width;
    CGFloat hrate = maxSize.height/size.height;
    rate = MIN(wrate, hrate);

    fitSize.width = fitSize.width*rate;
    fitSize.height = fitSize.height*rate;
    
//    if (wrate > hrate) {
//        // 缩小或扩大宽度
//
//    } else {
//        // 缩小或扩大高度
//        fitSize.height = maxSize.height;
//        fitSize.width = fitSize.height*rate;
//    }
    
    return fitSize;
}

@end
