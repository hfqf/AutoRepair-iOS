//
//  AddCustomViewController.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/29.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"

@interface AddRepairHistoryViewController : SpeRefreshAndLoadViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{    
    UITextField *m_kmInput;
    UITextField *m_timeInput;
    UITextView *m_repairTypeInput;
    UITextView *m_moreInput;
    UITextField *m_tipCircleInput;
    
    UITextField *m_payDesc;
    UITextField *m_payNum;
    UITextField *m_payPrice;
    UISwitch *m_isNeedTipSwitcher;
}
@property(nonatomic,strong)ADTRepairInfo *m_currentData;
- (id)initWithInfo:(ADTRepairInfo *)info;

@end
