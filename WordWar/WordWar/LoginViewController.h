//
//  LoginViewController.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"

@interface LoginViewController : UIViewController

- (instancetype)initWithDelegate:(id)delegate;
- (LoginView *)getLoginView;

@end
