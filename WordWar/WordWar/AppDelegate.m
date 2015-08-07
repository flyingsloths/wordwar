//
//  AppDelegate.m
//  WordWar
//
//  Created by Christine Lee on 7/2/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "GameManager.h"
#import "Player.h"
#import "GameViewController.h"
#import "GameLobbyView.h"
#import "GameLobbyViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /***************
     * PARSE SETUP *
     ***************/
    [Parse setApplicationId:@"XKl1tNxlg8lCfSdKILurlBgRNQ9gRfF3zh8j5nkO"
                  clientKey:@"iHo7Zx0QNyzzysPXWT5vFUhX2GGS2Z3BxyebJuJy"];
//    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    /******************
     * FACEBOOK LOGIN *
     ******************/
    [FBSDKLoginButton class];
    
    /****************
     * WINDOW SETUP *
     ****************/
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]]; // Initiate window
    GameLobbyViewController *vc = [[GameLobbyViewController alloc] init];
    NSLog(@"In app delegate");
//    GameViewController *vc = [[GameViewController alloc] init];

    
    self.window.rootViewController = vc; // Initiate View Controller
    [self.window.rootViewController showViewController:self.window.rootViewController
                                                sender:nil];
    
    [self.window makeKeyAndVisible]; // Make Key and Visible
    
//    return YES;
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
