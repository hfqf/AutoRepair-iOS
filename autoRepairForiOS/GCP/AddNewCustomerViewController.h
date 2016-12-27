//
//  AddNewCustomerViewController.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "BaseViewController.h"

@interface AddNewCustomerViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *m_bg;
    
    UITextField *m_carCodeInput;
    UITextField *m_userNameInput;
    UITextField *m_telInput;
    UITextView *m_carTypeInput;
}
@property(nonatomic,strong)ADTContacterInfo *m_currentData;
- (id)initWithContacer:(ADTContacterInfo *)info;


@end
