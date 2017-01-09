//
//  AddCustomViewController.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/29.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "BaseViewController.h"

@interface AddRepairHistoryViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIScrollView *m_bg;
    
    UITextField *m_kmInput;
    UITextField *m_timeInput;
    UITextField *m_repairTypeInput;
    UITextView *m_moreInput;
    UITextField *m_tipCircleInput;
    UISwitch *m_isNeedTipSwitcher;
    BOOL        m_isAdd;
}
@property(nonatomic,strong)ADTRepairInfo *m_currentData;
- (id)initWithInfo:(ADTRepairInfo *)info;

@end
