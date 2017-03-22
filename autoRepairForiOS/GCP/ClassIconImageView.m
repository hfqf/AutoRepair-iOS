//
//  ClassIconImageView.m
//  xxt_xj
//
//  Created by Points on 14-6-18.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import "ClassIconImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ClassIconImageView
@synthesize classIconView= classIconView;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        classIconView = [[EGOImageView alloc]initWithFrame:CGRectMake(3,3, frame.size.width-6, frame.size.height-6)];
        [self addSubview:classIconView];
    }
    return self;
}

- (void)setNewImage:(id)url withDefaultImg:(NSString *)defaultImgage
{
    
    [classIconView setPlaceholderImage:[UIImage imageNamed:defaultImgage]];
    classIconView.layer.masksToBounds = YES;
    classIconView.layer.cornerRadius = (self.frame.size.width-6)/2;
    
    if([url isKindOfClass:[NSURL class]])
    {
        [classIconView setImageURL:url];
    }
    else if([url isKindOfClass:[NSString class]]){
        [classIconView setImageURL:[NSURL URLWithString:url]];
    }
    else
    {
        [classIconView setImage:(UIImage *)url];
    }
}

- (void)setNewImage:(id)url WithSpeWith:(int)sepWidth withDefaultImg:(NSString *)defaultImgage
{
    [self setBackgroundColor:[UIColor whiteColor]];
    [classIconView setFrame:CGRectMake(sepWidth,sepWidth, self.frame.size.width-sepWidth*2, self.frame.size.height-sepWidth*2)];
    [classIconView setPlaceholderImage:[UIImage imageNamed:defaultImgage]];
    classIconView.layer.masksToBounds = YES;
    classIconView.layer.cornerRadius = (self.frame.size.width-sepWidth*2)/2;
    self.layer.cornerRadius = self.frame.size.width/2;
    if([url isKindOfClass:[NSURL class]])
    {
        [classIconView setImageURL:url];
    }
    else if([url isKindOfClass:[NSString class]]){
        [classIconView setImageURL:[NSURL URLWithString:url]];
    }
    else
    {
        [classIconView setImage:(UIImage *)url];
    }
}

- (void)setClassImage:(id)url withDefaultImg:(NSString *)defaultImgage
{
    [self setImage:[UIImage imageNamed:@"head_boundrary@2x"]];
    if([url isKindOfClass:[NSURL class]])
    {
        if([[(NSURL *)url absoluteString]rangeOfString:@"jpg"].length == 0 && [[(NSURL *)url absoluteString]rangeOfString:@"png"].length == 0)
        {
            [classIconView setImageForAllSDK:nil withDefaultImage:[UIImage imageNamed:defaultImgage]];
        }
        else
        {
            [classIconView setImageForAllSDK:(NSURL *)url withDefaultImage:[UIImage imageNamed:defaultImgage]];
        }
        
    }
    else
    {
        [classIconView setImage:(UIImage *)url];
    }
}

@end
