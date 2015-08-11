//
//  WaitingRoomManager.m
//  WordWar
//
//  Created by Flying Sloths on 7/15/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "WaitingRoomManager.h"

#define FIREBASE_URL @"https://word-war.firebaseio.com/"

@interface WaitingRoomManager ()

@property (nonatomic, copy) GameRoom *gameRoom;


@end

@implementation WaitingRoomManager

// TODO: THIS WHOLE FILE IS ONE MASSIVE TODO

#pragma mark -
#pragma mark Initializers and Description
- (instancetype)initWithGameRoom:(GameRoom *)gameRoom
                        delegate:(id)delegate {
    self = [super init];
    if (self) {
        
        _delegate = delegate; 
        
        _gameRoom = gameRoom;
        
        // Create Firebase channel for game lobby and game with unique firebase ID
        NSString *firebaseURLwithID = [FIREBASE_URL stringByAppendingString:gameRoom.objectId];
        self.firebase = [[Firebase alloc] initWithUrl:firebaseURLwithID];
        
        // Listen for parse to update
        [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            [self updateWaitingRoom];
         }];
        
        // Firebase update value
        [self.firebase setValue:@"update"];
        
    }
    return self;
}

#pragma mark -
#pragma mark Setters
- (void)setRoomName:(NSString *)roomName {
    
    
}

#pragma mark -
#pragma mark Receiver
- (void)updateWaitingRoom {
    // Pull parse game room
    // _gameRoom = updated GameRoom pulled from parse
    // players = _gameRoom.players
    // update View
}


- (void)updatePlayersList {
    self.players = _gameRoom.players;
    [_delegate updateWaitingRoomPlayers:self.players];
}

- (void)updateGameRoomName {
    self.roomName = _gameRoom.roomName;
    [_delegate updateRoomName:self.roomName];
}

#pragma mark -
#pragma mark Begin Game
- (void)readyButtonPressed {
        // Initialize game manager and game view controller
        // play game
}


@end
