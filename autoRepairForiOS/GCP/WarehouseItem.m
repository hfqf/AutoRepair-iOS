//
//  WarehouseItem.m
//  AutoRepairHelper3
//
//  Created by points on 2017/8/26.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehouseItem.h"

@implementation WarehouseItem

- (id)initWith:(CGRect)frame
 withRessource:(NSDictionary *)resource
       withNum:(NSInteger)num
{
   if(self = [super initWithFrame:frame])
   {
       self.m_itemType = [resource[@"type"]integerValue];

       UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
       NSString *_icon = resource[@"icon"];
       NSString *_title = resource[@"title"];
       UIImage *icon = [UIImage imageNamed:_icon];
       if(icon){
           [btn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
           [btn setImage:icon forState:UIControlStateNormal];

           UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), frame.size.width, 20)];
           [tip setText:_title];
           [tip setTextAlignment:NSTextAlignmentCenter];
           [tip setTextColor:[UIColor blackColor]];
           [tip setFont:[UIFont systemFontOfSize:15]];
           [self addSubview:tip];
       }else{
           [btn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
           [btn setTitle:_title forState:UIControlStateNormal];
           [btn setTitleColor:KEY_COMMON_CORLOR forState:UIControlStateNormal];
       }
       [self addSubview:btn];

       if(num >0){
           UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-20,0,20, 20)];
           numLab.layer.cornerRadius = 10;
           numLab.layer.borderColor = [UIColor redColor].CGColor;
           numLab.layer.borderWidth = 0.5;
           [numLab setText:[NSString stringWithFormat:@"%lu",num]];
           [numLab setTextAlignment:NSTextAlignmentCenter];
           [numLab setTextColor:[UIColor redColor]];
           [numLab setFont:[UIFont systemFontOfSize:11]];
           [self addSubview:numLab];
       }
   }
    return self;
}


- (void)btnClicked
{
    self.itemBlock(self.m_itemType);
}
@end
