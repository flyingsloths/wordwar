//
//  GameLobbyViewController.h
//  WordWar
//
//  Created by Christine Lee on 7/8/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GameLobbyView.h"
#import "GameLobbyViewControllerDelegate.h"
#import "GameLobbyManagerDelegate.h"
#import "LobbyTableViewController.h"
#import "GameRoom.h"
@class GameLobbyManager;
@protocol GameLobbyViewControllerDelegate;

@interface GameLobbyViewController : UIViewController <GameLobbyViewDelegate, GameLobbyManagerDelegate, FBSDKLoginButtonDelegate>

@property (nonatomic, strong) GameLobbyManager *gameLobbyManager;
@property (nonatomic, strong) LobbyTableViewController *tableViewController;
@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

- (void)joinGameWithId:(NSString *)roomId;
- (BOOL)isDuplicateRoom:(NSString *)room;
- (void)fetchUserInfo;
- (void)joinGame;
- (void)createButtonRevertToNormal;

@end
