//
//  WarehouseItem.h
//  AutoRepairHelper3
//
//  Created by points on 2017/8/26.
//  Copyright © 2017年 Poitns. All rights reserved.
//

typedef void(^WarehouseItemBlock)(NSInteger selectTag);


#import <UIKit/UIKit.h>

@interface WarehouseItem : UIView
@property(nonatomic,strong)WarehouseItemBlock itemBlock;
@property(assign)NSInteger m_itemType;

- (id)initWith:(CGRect)frame
 withRessource:(NSDictionary *)resource
       withNum:(NSInteger)num;
@end
