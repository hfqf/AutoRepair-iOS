//
//  ClassIconImageView.h
//  xxt_xj
//
//  Created by Points on 14-6-18.
//  Copyright (c) 2014年 Points. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface ClassIconImageView : UIImageView
{
    EGOImageView *classIconView;
}
@property(nonatomic,retain) EGOImageView *classIconView;


- (void)setNewImage:(id)url withDefaultImg:(NSString *)defaultImgage;

- (void)setNewImage:(id)url WithSpeWith:(int)sepWidth  withDefaultImg:(NSString *)defaultImgage;

- (void)setClassImage:(id)url withDefaultImg:(NSString *)defaultImgage;
@end
