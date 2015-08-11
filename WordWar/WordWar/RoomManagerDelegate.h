//
//  RoomManagerDelegate.h
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#ifndef WordWar_RoomManagerDelegate_h
#define WordWar_RoomManagerDelegate_h

@protocol RoomManagerDelegate <NSObject>
@required
- (void)updatePlayers:(NSMutableArray *)players;
- (void)startGame:(GameRoom *)gameRoom
             myID:(NSString *)myID;
@end


#endif
