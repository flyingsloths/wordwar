//
//  GameView.h
//  WordWar
//
//  Created by Flying Sloths on 7/8/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordBomb.h"
@class Player;

@protocol GameViewDelegate <NSObject>

@required
- (void)countdownFinished;
- (void)submitWord:(NSString *)word
                         to:(NSString *)to;
- (BOOL)checkWord:(NSString *)word;
- (BOOL)checkWordHasNotBeenUsed:(NSString *)word;
- (BOOL)checkDictionaryForWord:(NSString *)word;


@end

#define BIG_FONT @"BowlbyOneSC-Regular"
//#define SMALL_FONT @"BowlbyOneSC-Regular"
//#define BIG_FONT @"GoudyMediaeval-DemiBold"
//#define SMALL_FONT @"GoudyMediaeval-DemiBold"
#define SMALL_FONT @"OpenSans-Semibold"

@interface GameView : UIView

@property (nonatomic, copy) NSArray *hand;
@property (nonatomic) NSInteger shuffleCount;

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                    otherPlayers:(NSArray *)players
                        delegate:(id<GameViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;
- (void)setMessageText:(NSString *)messageText
           messageType:(NSString *)messageType
        affectedPlayer:(Player *)affectedPlayer
         sendingPlayer:(Player *)sendingPlayer;
- (void)setHand:(NSArray *)hand;
- (void)toggleFreeze;
- (void)toggleHide;
- (void)destroyBomb;
- (void)destroyCatapult;
- (void)destroyMessageTexts;
- (void)destroyWordViews;
- (void)setShuffleCount:(NSInteger)shuffleCount;
- (void)setTimerText:(NSString *)timerText
            timeLeft:(CGFloat)timeLeft;
- (void)clearWordCreationView;
- (BOOL)checkWord:(NSString *)word;
- (void)setRatios:(NSArray *)ratios;
- (void)setRanks;
- (void)setScores;
+ (CGPoint)centerForPlayerBubbleWithIndex:(NSInteger)index
                          numberOfPlayers:(NSInteger)playerCount
                            widthOfScreen:(CGFloat)width;
+ (void)playShortSound:(NSString *)fileName
             extension:(NSString *)extension;

@end
