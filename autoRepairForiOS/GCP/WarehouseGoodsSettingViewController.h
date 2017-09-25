//
//  WarehouseGoodsSettingViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/9/3.
//  Copyright © 2017年 Poitns. All rights reserved.
//

@protocol WarehouseGoodsSettingViewControllerDelegate <NSObject>

@required

- (void)onSelectGoodsType:(NSDictionary *)goodsInfo;

- (void)onSelectedServices:(NSArray *)arrServices;
@end

#import "SpeRefreshAndLoadViewController.h"

@interface WarehouseTopTypeInfo :NSObject
@property(assign)BOOL m_isOpen;
@property(nonatomic,strong)NSDictionary *m_info;
@property(nonatomic,strong)NSArray *m_arrTypes;

@end


@interface WarehouseSubTypeInfo :NSObject
@property(nonatomic,strong) NSString *m_name;
@property(nonatomic,strong) NSString *m_id;
@property(nonatomic,strong) NSString *m_price;
@property(nonatomic,strong) NSString * m_selectedNum;
@property(nonatomic,strong) NSString * m_topicId;
@property(assign)BOOL m_isForSelect;
@end

@interface WarehouseGoodsSettingViewController : SpeRefreshAndLoadViewController
@property(assign)BOOL m_isSelect;
@property(nonatomic,weak)id<WarehouseGoodsSettingViewControllerDelegate>m_selectDelegate;
- (id)initForSelectType;
@end
