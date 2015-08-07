//
//  RoomTableViewController.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/22/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithPlayers:(NSMutableArray *)players;
- (void)updatePlayersList:(NSMutableArray *)players;

@end
