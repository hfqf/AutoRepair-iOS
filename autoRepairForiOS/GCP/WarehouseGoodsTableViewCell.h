//
//  WarehouseGoodsTableViewCell.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/4.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarehouseGoodsTableViewCell : UITableViewCell
{
    EGOImageView *m_head;
    UILabel *m_nameLab;
    UILabel *m_priceLab;}

@property (nonatomic,strong)WareHouseGoods *infoData;
@end
