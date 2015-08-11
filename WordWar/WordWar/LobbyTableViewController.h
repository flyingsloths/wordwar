//
//  LobbyTableViewController.h
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameLobbyViewController;

@interface LobbyTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (void)updateGameRoomList:(NSArray *)names roomIds:(NSArray *)ids;
- (NSString *)selectedRoom;
- (NSString *)selectedId;
- (NSArray *)roomNames;
- (void)setJoinRoomTarget:(GameLobbyViewController *)target;

@end
