//
//  GameViewControllerDelegate.h
//  WordWar
//
//  Created by Christine Lee on 7/9/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "GameRoom.h"

@protocol GameViewControllerDelegate <NSObject>
@required
- (BOOL)inSession;
- (void)initializeFirebase:(NSString *)gameID;
- (void)restartGame;
- (void)submitWord:(NSString *)word
              to:(NSString *)to;
- (void)shuffleHandAndSubtract:(BOOL)subtract;
- (void)deleteGame:(GameRoom *)gameRoom;
@end