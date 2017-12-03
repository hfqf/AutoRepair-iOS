//
//  AddNewEmployeeViewController.h
//  AutoRepairHelper3
//
//  Created by 皇甫启飞 on 2017/12/1.
//  Copyright © 2017年 Poitns. All rights reserved.
//

#import "SpeRefreshAndLoadViewController.h"

@interface AddNewEmployeeViewController : SpeRefreshAndLoadViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *m_bg;

    UITextField *m_userNameInput;
    UITextField *m_telInput;
    UITextField *m_pwdInput;
    UITextField *m_roleTypeInput;

    EGOImageView *head;
}
@property(nonatomic,strong) ADTEmployeeInfo *m_currentData;

- (id)initWith:(ADTEmployeeInfo *)employee;

@end
