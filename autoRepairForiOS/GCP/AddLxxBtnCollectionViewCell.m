//
//  AddLxxBtnCollectionViewCell.m
//  shaobao
//
//  Created by 皇甫启飞 on 2017/10/7.
//  Copyright © 2017年 com.kinggrid. All rights reserved.
//

#import "AddLxxBtnCollectionViewCell.h"

@implementation AddLxxBtnCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setFrame:CGRectMake(10,5, MAIN_WIDTH-20, 50)];
        [_addBtn setBackgroundColor:KEY_COMMON_CORLOR];
        [_addBtn setTitle:@"提交" forState:0];
        _addBtn.layer.cornerRadius = 4;
        [_addBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self addSubview:_addBtn];
    }
    return self;
}
@end
