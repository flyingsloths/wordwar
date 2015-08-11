//
//  GameLobbyManagerDelegate.h
//  WordWar
//
//  Created by Flying Sloths on 7/13/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

@protocol GameLobbyManagerDelegate <NSObject>
@required
- (void)updateGameList:(NSArray *)roomNames roomIds:(NSArray *)roomIds;
- (void)joinGameWithId:(NSString *)roomId;
- (void)stopSpinner;
- (void)startSpinner;
@end
