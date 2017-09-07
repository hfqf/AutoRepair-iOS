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
    EGOImageView *m_head;
    
    UILabel *m_nameLab;
    UILabel *m_isInShopLab;
    UILabel *m_carInfoLab;
    UILabel *m_statelab;
    
    UILabel *m_typelab;
    UILabel *m_pricelab;
    UIView *m_sep;
    UILabel *m_enterTimelab;
    UILabel *m_wantCompletedTimelab;
    
    UILabel *m_indeLab;
}
@property(nonatomic,strong)ADTRepairInfo *info;

@end
