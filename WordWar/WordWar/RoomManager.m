//
//  RoomManager.m
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "RoomManager.h"
#import "RoomViewController.h"
#import "RoomManagerDelegate.h"
#import "Player.h"
#import "ParsePlayer.h"


@implementation RoomManager 

#pragma mark -
#pragma mark Initializers and Description
- (instancetype)initWithGameRoom:(GameRoom *)gameRoom
                        delegate:(id<RoomManagerDelegate>)delegate
                      facebookId:(NSString *)fbid {
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.gameRoom = gameRoom;
        self.myId = fbid;
        
        // Create Firebase channel for game lobby and game with unique firebase ID
        NSString *firebaseURLwithID = [FIREBASE_URL stringByAppendingString:gameRoom.objectId];
        self.firebase = [[Firebase alloc] initWithUrl:firebaseURLwithID];
        NSLog(@"Firebase channel: %@", firebaseURLwithID);
        
        // Listen for Firebase signal
        [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            NSLog(@"Did we receive something from firebase");
            if ([snapshot.value isEqualToString:@"start"]) {
                NSLog(@"Received Firebase signal. Starting game");
                [self startGame];
            }
            else if ([snapshot.value isEqualToString:@"update"]) {
                NSLog(@"Received Firebase signal. Updating game");
                [self updateWaitingRoom];
            }
            else if ([snapshot.value isEqualToString:@"delete"]) {
                NSLog(@"Received Firebase signal. Deleting room");
                [self deleteRoom];
            }
        }];

        // Firebase update value
        Firebase *startRef = [self.firebase childByAutoId];
        [startRef setValue:@"update"];
    }
    return self;
}

- (void)deleteRoom {
    NSString *lobbyURL = [FIREBASE_URL stringByAppendingString:@"/lobby"];
    Firebase *lobbyFirebase = [[Firebase alloc] initWithUrl:lobbyURL];
    [lobbyFirebase setValue: @"delete"];
}

- (void)startGame {
    [_delegate startGame:self.gameRoom myID:self.myId];
}


#pragma mark -
#pragma mark RoomViewControllerDelegate
- (void)updateWaitingRoom {
    
    // Query Parse for game room
    PFQuery *query = [PFQuery queryWithClassName:@"GameRoom"];
    [query includeKey:@"playerObjects"];
    [query getObjectInBackgroundWithId:self.gameRoom.objectId block:^(PFObject *gameRoom, NSError *error) {
        self.gameRoom = (GameRoom *)gameRoom;
        
        // Store pictures locally
//        NSMutableArray *pictures = [[NSMutableArray alloc] init];
//        NSMutableArray *playerObjects = self.gameRoom.playerObjects;
//        for (Player *player in playerObjects) {
//            [pictures addObject:player.profilePic];
//        }
//        self.pictures = pictures;
        
        // Convert from ParsePlayers to Players
        NSArray *playerObjects = self.gameRoom.playerObjects;
        NSMutableArray *players = [[NSMutableArray alloc] init];
        int i=0;
        for (ParsePlayer *parsePlayer in playerObjects) {
            Player *newPlayer = [[Player alloc] initWithID:parsePlayer.playerId realName:parsePlayer.playerName playerIndex:i baseScore:50 profilePic:nil];
            [players addObject:newPlayer];
        }
        [_delegate updatePlayers:players];
    }];
}

- (void)leaveRoom {
    NSLog(@"In manager");
    // Query Parse and delete self from player array
    PFQuery *query = [PFQuery queryWithClassName:@"GameRoom"];
    [query includeKey:@"playerObjects"];
    [query getObjectInBackgroundWithId:self.gameRoom.objectId block:^(PFObject *gameRoom, NSError *error) {
        
        NSArray *playerObjects = gameRoom[@"playerObjects"];
        
        // Delete room if last player is leaving
        if ([playerObjects count] == 1) {
            NSLog(@"Last player leaving");
            [gameRoom deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self deleteRoom];
                }
            }];
        }
        
        // Otherwise remove player
        else {
            int i=0;
            for (ParsePlayer *player in playerObjects) {
                if ([player.playerId isEqualToString:self.myId]) {
                    [gameRoom removeObject:gameRoom[@"playerObjects"][i] forKey:@"playerObjects"];
                    break;
                }
                i++;
            }
            
            [gameRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Player has been removed");
                    Firebase *startRef = [self.firebase childByAutoId];
                    [startRef setValue:@"update"];
                }
            }];
        }
    }];
}

- (NSString *)getTitle {
    return self.gameRoom.roomName;
}

#pragma mark -
#pragma Receiver
- (void)readyClicked {
    // Firebase signal to start game
    Firebase *startRef = [self.firebase childByAutoId];
    [startRef setValue:@"start"];
    
    // Update game room status to playing
    PFQuery *query = [PFQuery queryWithClassName:@"GameRoom"];
    [query getObjectInBackgroundWithId:self.gameRoom.objectId block:^(PFObject *gameRoom, NSError *error) {
        gameRoom[@"status"] = @"playing";
        NSLog(@"Changed game room status to playing");
        [gameRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            // Update lobby to remove game room from list
            if (succeeded) {
                NSString *lobbyURL = [FIREBASE_URL stringByAppendingString:@"/lobby"];
                Firebase *lobbyRef = [[[Firebase alloc] initWithUrl:lobbyURL] childByAutoId];
                [lobbyRef setValue: @"update"];
            }
        }];
    }];

}


@end
