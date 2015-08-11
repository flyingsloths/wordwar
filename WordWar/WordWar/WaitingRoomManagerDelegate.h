//
//  WaitingRoomManagerDelegate.h
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

@protocol WaitingRoomManagerDelegate <NSObject>
@required
- (void)updateWaitingRoomPlayers:(NSArray *)players;
- (void)updateRoomName:(NSString *)roomName;
@end
