//
//  LoginView.h
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginView : UIView
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end
