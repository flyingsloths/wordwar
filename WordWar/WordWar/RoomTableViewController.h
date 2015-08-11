//
//  RoomTableViewController.h
//  WordWar
//
//  Created by Flying Sloths on 7/22/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithPlayers:(NSMutableArray *)players;
- (void)updatePlayersList:(NSMutableArray *)players;

@end
