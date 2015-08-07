//
//  GameManagerDelegate.h
//  WordWar
//
//  Created by Christine Lee on 7/9/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//
//  FYI, put into a new file to break the #import cycle that is created
//  because GameViewController and GameManager are both delegates for
//  each other.
//

@class Player;

@protocol GameManagerDelegate <NSObject> // Initialize protocol
@required
- (void)setMessageText:(NSString *)message
       messageType:(NSString *)messageType
    affectedPlayer:(Player *)affectedPlayer
     sendingPlayer:(Player *)sendingPlayer;
- (void)toggleFreeze;
- (void)toggleHide;
- (void)updateShuffleCount:(NSInteger)myShuffleCount;
- (void)updateHandView:(NSArray *)hand;
- (void)clearWordCreationView;
- (void)setTime:(NSString *)timeText
       timeLeft:(CGFloat)timeLeft;
- (void)endGame;
- (void)updateRatios:(NSArray *)ratios;
- (void)updateRanks;
- (void)updateScores;
@end