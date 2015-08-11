//
//  GameLobbyManager.m
//  WordWar
//
//  Created by Flying Sloths on 7/13/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "GameLobbyManager.h"
#import "GameRoom.h"
#import "GameLobbyManagerDelegate.h"
#import "RoomManager.h"
#import "Player.h"
#import "ParsePlayer.h"

#define FIREBASE_LOBBY_URL @"https://word-war.firebaseio.com/lobby"

@implementation GameLobbyManager

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.firebase = [[Firebase alloc] initWithUrl:FIREBASE_LOBBY_URL];
        [self.firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot != (FDataSnapshot *)[NSNull null]) {
                NSLog(@"Received Firebase signal: %@", snapshot.value);
                [self updateGameList];
            }
        }];
    }
    return self;
}


# pragma mark -
# pragma mark GameLobbyViewControllerDelegate
- (void)updateGameList {
    PFQuery *query = [GameRoom query];
    [query whereKey:@"status" equalTo:@"active"];
    NSLog(@"In update game list. About to find objects from Parse.");
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"In update game list. Finished finding objects from Parse.");
        NSMutableArray *roomIds = [[NSMutableArray alloc] init];
        NSMutableArray *roomNames = [[NSMutableArray alloc] init];
        for (GameRoom *object in objects) {
            [roomIds addObject:object.objectId];
            [roomNames addObject:object.roomName];
        }
        [_delegate updateGameList:roomNames roomIds:roomIds];
    }];
}

- (void)createGameWithName:(NSString *)roomName {
    GameRoom *gameRoom = [GameRoom object];
    gameRoom.status = @"active";
    gameRoom.roomName = roomName;
    gameRoom.playerObjects = nil;
    NSLog(@"In Create game. About to save object");
    [gameRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"In create game. Finished saving object");
            
            // Sends Firebase signal
            [self.firebase setValue:gameRoom.objectId];
            
            // Joins the created Firebase channel
            [_delegate joinGameWithId:gameRoom.objectId];
        } else {
            
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)joinGameWithName:(NSString *)roomId
                  player:(Player *)player
               withBlock:(void(^)(GameRoom *))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameRoom"];
    [query includeKey:@"playerObjects"];
    NSLog(@"In join game with name. Getting game room from Parse.");
    
    [query getObjectInBackgroundWithId:roomId block:^(PFObject *gameRoom, NSError *error) {
        NSLog(@"In join game with name. Finished getting game room from Parse.");
        
        // Convert from Player to ParsePlayer
        ParsePlayer *parsePlayer = [ParsePlayer object];
        parsePlayer.playerName = player.realName;
        parsePlayer.playerId = player.fbID;
        NSData *pictureData = UIImagePNGRepresentation(player.profilePic);
        parsePlayer.picture = [PFFile fileWithName:@"picture.png" data:pictureData];
        [gameRoom addObject:parsePlayer forKey:@"playerObjects"];
        
        // Check if full
        NSArray *players = gameRoom[@"playerObjects"];
        if ([players count] == 4) {
            gameRoom[@"status"] = @"full";
//            Firebase *fullRef = [self.firebase childByAutoId];
            [self.firebase setValue:gameRoom.objectId];
        }
        
        NSLog(@"In join game with name. About to save updated game room.");
        [gameRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"In join game with name. Finished saving updated game room");
                completion((GameRoom *)gameRoom);
            }
        }];
    }];
    
}

@end
