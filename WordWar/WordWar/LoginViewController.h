//
//  LoginViewController.h
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"

@interface LoginViewController : UIViewController

- (instancetype)initWithDelegate:(id)delegate;
- (LoginView *)getLoginView;

@end
