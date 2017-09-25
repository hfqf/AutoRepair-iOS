//
//  ServiceManagerTableViewCell.h
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/9/24.
//  Copyright © 2017年 Poitns. All rights reserved.
//
@protocol ServiceManagerTableViewCellDelegate

@required

- (void)onReload;
@end

#import <UIKit/UIKit.h>
#import "WarehouseGoodsSettingViewController.h"
@interface ServiceManagerTableViewCell : UITableViewCell
{
    UILabel *tip1;


    UIButton *reduceBtn;

    UILabel *serviceNeedNumLab ;

    UIButton *addNumBtn ;
}
@property(nonatomic,weak)id<ServiceManagerTableViewCellDelegate>m_delegate;
@property(nonatomic,strong) WarehouseSubTypeInfo *subType;
@end
