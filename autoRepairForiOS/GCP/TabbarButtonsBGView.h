//
//  TabbarButtonsBGView.h
//  xxt_xj
//
//  Created by Points on 13-12-20.
//  Copyright (c) 2013年 Points. All rights reserved.
//

@protocol TabbarButtonsBGViewDelegate <NSObject>

@required

- (void)onSelectedWithButtonIndex:(int)index;

@end
#import <UIKit/UIKit.h>
#import "TabbarCustomButton.h"
@interface TabbarButtonsBGView : UIImageView
{
    
}
@property(nonatomic,strong)NSArray *m_arrBGButton;

@property(nonatomic,weak)id<TabbarButtonsBGViewDelegate>m_delegate;

- (id)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)arrTitle
withUnSelectedImgArray:(NSArray *)arrUnSelected
       withSelectedArr:(NSArray *)arrSelected
      withButtonNum:(int)num;

- (void)refreshWithCurrentSelected:(int)index;
@end
