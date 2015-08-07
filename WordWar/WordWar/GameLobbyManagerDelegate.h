//
//  GameLobbyManagerDelegate.h
//  WordWar
//
//  Created by Zareen Choudhury on 7/13/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

@protocol GameLobbyManagerDelegate <NSObject>
@required
- (void)updateGameList:(NSArray *)roomNames roomIds:(NSArray *)roomIds;
- (void)joinGameWithId:(NSString *)roomId;
- (void)stopSpinner;
- (void)startSpinner;
@end
