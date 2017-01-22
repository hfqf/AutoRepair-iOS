//
//  EmptyTipView.h
//  JZH_BASE
//
//  Created by Points on 13-11-18.
//  Copyright (c) 2013年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyTipView : UIView<NSCopying>

@property(weak,nonatomic)id delegate;

- (id)initWithFrame:(CGRect)frame WithTip:(NSString *)tip;

- (id)initWithOrderFrame:(CGRect)frame WithTip:(NSString *)tip;
@end
