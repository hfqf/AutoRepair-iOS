//
//  LxxTableViewCell.h
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//
#import "ADTLxxItemInfo.h"
@protocol LxxTableViewCellDelegate<NSObject>
@required

- (void)onLxxTableViewCellDelegateForDel:(ADTLxxItemInfo *)info;

- (void)onLxxTableViewCellDelegateForComment:(ADTLxxItemInfo *)info;

- (void)onTap:(NSInteger)index with:(NSArray *)arrUrl;

- (void)onHeadClicked:(NSString *)userId;
@end
#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
@interface LxxTableViewCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
{
    EGOImageView *m_head;
    UILabel *m_userType;
    UILabel *m_nameLab;
    UILabel *m_timeLab;
    UILabel *m_addressLab;
    UILabel *m_contentLab;
    UITableView *m_table;

    UIButton *m_delBtn;
    UIButton *m_commentBtn;

    EGOImageButton *m_picview1;
    EGOImageButton *m_picview2;
    EGOImageButton *m_picview3;
    EGOImageButton *m_picview4;
    EGOImageButton *m_picview5;
    EGOImageButton *m_picview6;
    UIView *m_sep;
}
@property(nonatomic,weak)id<LxxTableViewCellDelegate>m_delegate;

@property(nonatomic,strong) ADTLxxItemInfo *currentData;
@property(nonatomic,strong)NSMutableArray *m_arrImageViews;

@end
