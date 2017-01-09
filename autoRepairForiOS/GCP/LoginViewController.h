//
//  LoginViewController.h
//  AutoRepairHelper
//
//  Created by points on 16/11/20.
//  Copyright © 2016年 Poitns. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameInput;

@property (weak, nonatomic) IBOutlet UITextField *pwdInput;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end
