//
//  WarehousePurchaseEditView.m
//  AutoRepairHelper3
//
//  Created by points on 2017/9/9.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "WarehousePurchaseEditView.h"

@implementation WarehousePurchaseEditView

- (id)initWith:(WareHouseGoods *)goods withDelegate:(id<WarehousePurchaseEditViewDelegate>)delegate
{
    if(self = [self initWithFrame:MAIN_FRAME]){

        self.m_goods = goods;
        self.m_delegate = delegate;
        self.layer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8].CGColor;

        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(20, 80, MAIN_WIDTH-40, 150)];
        [bg setBackgroundColor:KEY_COMMON_LIGHT_BLUE_CORLOR];
        bg.layer.cornerRadius = 4;
        [self addSubview:bg];

        UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 80, 20)];
        [tip1 setTextAlignment:NSTextAlignmentLeft];
        [tip1 setTextColor:[UIColor whiteColor]];
        [tip1 setText:@"采购价格"];
        [tip1 setFont:[UIFont systemFontOfSize:15]];
        [bg addSubview:tip1];

        m_priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(bg.frame.size.width-120, 20, 110, 15)];
        m_priceTextField.delegate = self;
        m_priceTextField.placeholder = @"0";
        m_priceTextField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        m_priceTextField.text = goods.m_costprice;
        m_priceTextField.textAlignment = NSTextAlignmentRight;
        m_priceTextField.textColor = [UIColor whiteColor];
        m_priceTextField.returnKeyType = UIReturnKeyDone;
        m_priceTextField.font =[UIFont systemFontOfSize:14];
        [bg addSubview:m_priceTextField];


        UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 80, 20)];
        [tip2 setTextAlignment:NSTextAlignmentLeft];
        [tip2 setTextColor:[UIColor whiteColor]];
        [tip2 setText:@"采购数量"];
        [tip2 setFont:[UIFont systemFontOfSize:15]];
        [bg addSubview:tip2];

        m_numTextField = [[UITextField alloc]initWithFrame:CGRectMake(bg.frame.size.width-120,70, 110, 15)];
        m_numTextField.delegate = self;
        m_numTextField.textAlignment = NSTextAlignmentRight;
        m_numTextField.placeholder = @"0";
        m_numTextField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        m_numTextField.text = goods.m_num;
        m_numTextField.textColor = [UIColor whiteColor];
        m_numTextField.returnKeyType = UIReturnKeyDone;
        m_numTextField.font =[UIFont systemFontOfSize:14];
        [bg addSubview:m_numTextField];


        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setFrame:CGRectMake(0, 110, 60, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bg addSubview:cancelBtn];

        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setFrame:CGRectMake(bg.frame.size.width-60, 110, 60, 40)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bg addSubview:confirmBtn];

    }
    return self;
}


- (void)cancelBtnClicked
{
    [self removeFromSuperview];
}

- (void)confirmBtnClicked
{
    if(m_priceTextField.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"价格不能为空" inSuperView:self withDuration:1];
        return;
    }

    if(m_numTextField.text.length == 0){
        [PubllicMaskViewHelper showTipViewWith:@"数量不能为空" inSuperView:self withDuration:1];
        return;
    }
    self.m_goods.m_num = m_numTextField.text;
    self.m_goods.m_costprice = m_priceTextField.text;
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(onEditCompleted:)])
    {
        [self.m_delegate onEditCompleted:self.m_goods];
    }
    [self removeFromSuperview];
}

@end
