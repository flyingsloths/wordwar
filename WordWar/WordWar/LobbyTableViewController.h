//
//  LobbyTableViewController.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/14/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
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
