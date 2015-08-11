//
//  RoomManager.h
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "GameRoom.h"
#import "RoomViewControllerDelegate.h"
@protocol RoomManagerDelegate;
@class RoomViewController;

#define FIREBASE_URL @"https://word-war.firebaseio.com/"

//static NSInteger const BaseScore = 100;

@interface RoomManager : NSObject <RoomViewControllerDelegate> {
    __weak id <RoomManagerDelegate> _delegate;
}

@property (nonatomic, strong) GameRoom *gameRoom;
@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic, copy) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *myId;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithGameRoom:(GameRoom *)gameRoom
                        delegate:(id<RoomManagerDelegate>)delegate
                      facebookId:(NSString *)fbid;
- (void)deleteRoom;

@end
