//
//  AddNewCarcodeSelectViewController.h
//  AutoRepairHelper3
//
//  Created by points on 2017/3/29.
//  Copyright © 2017年 Poitns. All rights reserved.
//
@protocol AddNewCarcodeSelectViewControllerDelegate <NSObject>

@required

- (void)onInputedCarcode:(NSString *)carcode;


@end
#import "SpeRefreshAndLoadViewController.h"

@interface AddNewCarcodeSelectViewController : SpeRefreshAndLoadViewController<UITextFieldDelegate>
{
    UITextField *m_input1;
    UITextField *m_input2;
    UITextField *m_input3;
    UITextField *m_input4;
    UITextField *m_input5;
    UITextField *m_input6;
    UITextField *m_input7;
}

@property(nonatomic,weak)id<AddNewCarcodeSelectViewControllerDelegate>m_selectDelegate;

@end
