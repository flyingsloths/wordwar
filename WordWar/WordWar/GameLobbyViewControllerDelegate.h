//
//  GameLobbyViewControllerDelegate.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/13/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//
#import "GameRoom.h"
@class Player;
@class ParsePlayer;

@protocol GameLobbyViewControllerDelegate <NSObject>
@required
- (void)createGameWithName:(NSString *)roomName;
- (void)joinGameWithName:(NSString *)roomId
                  player:(Player *)player
               withBlock:(void(^)(GameRoom *))completion;
- (void)updateGameList;
@end