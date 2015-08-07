//
//  LoginView.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginView : UIView
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end
