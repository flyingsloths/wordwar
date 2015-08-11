//
//  LoginViewController.m
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LoginView.h"

@interface LoginViewController () {
    __weak id <FBSDKLoginButtonDelegate> _delegate;
}
@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        NSLog(@"In login view controller");
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"Login view controller viewDidLoad");
    self.loginView = [[LoginView alloc] init];
    self.view = self.loginView;
    self.loginView.loginButton.delegate = _delegate;
    self.loginView.loginButton.readPermissions = @[@"public_profile"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma Getters & Setters
- (LoginView *)getLoginView {
    return _loginView;
}

@end
