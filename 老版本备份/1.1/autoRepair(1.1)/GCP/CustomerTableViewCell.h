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
    UILabel *m_carCodeLab;
    UILabel *m_nameLab;
}

@property (nonatomic,strong)ADTContacterInfo *infoData;

@end
