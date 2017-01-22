//
//  RepairHistotyTableViewCell.h
//  AutoRepairHelper
//
//  Created by Points on 15/5/2.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairHistotyTableViewCell : UITableViewCell
{
    UILabel *m_lab1;
    UILabel *m_lab2;
    UILabel *m_lab3;
    UILabel *m_lab4;
}
@property(nonatomic,strong)ADTRepairInfo *info;

@end
