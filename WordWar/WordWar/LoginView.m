//
//  LoginView.m
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginView.h"

@interface LoginView ()

@property (nonatomic, strong) UITextView *creditView;

@end

@implementation LoginView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        /**************
         * VIEW SETUP *
         **************/
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.layer.contents = (id)[UIImage imageNamed:@"loginpage"].CGImage;
        
        /// VIEW ///
        [self setBackgroundColor:[UIColor whiteColor]];
        
        /// FACEBOOK LOGIN ///
        _loginButton = [[FBSDKLoginButton alloc] init];
        _loginButton.center = CGPointMake(width/2, height/2+200);
        [self addSubview:_loginButton];
    }

    return self;
}

@end
