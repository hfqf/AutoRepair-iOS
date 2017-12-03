//
//  AddNewCustomerViewController.h
//  AutoRepairHelper
//
//  Created by Points on 15/4/30.
//  Copyright (c) 2015年 Poitns. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"
#import "AddNewCarcodeSelectViewController.h"

@interface AddNewCustomerViewController : SpeRefreshAndLoadViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,AddNewCarcodeSelectViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *m_bg;
    
    UITextField *m_carCodeInput;
    UITextField *m_userNameInput;
    UITextField *m_telInput;
    UITextField *m_carTypeInput;
    UITextField *m_vinTypeInput;
    UITextField *m_registerTimeTypeInput;

    UITextField *m_yearCheckTimeInput;
    UITextField *m_safeCompanyInput;
    UITextField *m_safeNextTimeInput;

    
    
    EGOImageView *head;
}
@property(nonatomic,strong)ADTContacterInfo *m_currentData;
@property(nonatomic,strong)NSString *m_carcode;
- (id)initWithContacer:(ADTContacterInfo *)info;

- (id)initWithCarcode:(NSString *)carcode;
@end
