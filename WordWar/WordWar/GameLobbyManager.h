//
//  GameLobbyManager.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/13/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Firebase/Firebase.h>
#import "GameLobbyViewController.h"
#import "GameLobbyViewControllerDelegate.h"
#import "GameLobbyManagerDelegate.h"
@protocol GameLobbyViewControllerDelegate;

@interface GameLobbyManager : NSObject <GameLobbyViewControllerDelegate> {
    __weak id <GameLobbyManagerDelegate> _delegate;
}
@property (nonatomic, strong) Firebase *firebase;
- (instancetype)initWithDelegate:(id)delegate NS_DESIGNATED_INITIALIZER;
- (void)updateGameList;

@end
