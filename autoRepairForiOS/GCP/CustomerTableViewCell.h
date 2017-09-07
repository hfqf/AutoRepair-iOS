//
//  CustomerTableViewCell.h
//  AutoRepairHelper
//
//  Created by Points on 15/5/1.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTableViewCell : UITableViewCell
{
    EGOImageView *m_head;
    UILabel *m_carCodeLab;
    UILabel *m_nameLab;
    UILabel *m_telLab;
    UILabel *m_carTypeLab;
}

@property (nonatomic,strong)ADTContacterInfo *infoData;

@end
