//
//  WaitingRoomManager.h
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/15/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "WaitingRoomViewController.h"
#import "WaitingRoomManagerDelegate.h"
#import "GameRoom.h"
@protocol WaitingRoomViewControllerDelegate;

@interface WaitingRoomManager : NSObject <WaitingRoomViewControllerDelegate> {
    __weak id <WaitingRoomManagerDelegate> _delegate; // Initialize delegate
}

@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic, copy) NSMutableArray *players;
@property (nonatomic, copy) NSString *roomName;

- (instancetype)initWithGameRoom:(GameRoom *)gameRoom;
- (void)setRoomName:(NSString *)roomName;

@end
