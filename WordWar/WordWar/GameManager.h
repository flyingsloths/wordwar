//
//  GameManager.h
//  WordWar
//
//  Created by Christine Lee on 7/6/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//
//  GameManager keeps track of things that the current phone knows but other phones
//  should not know. For example, the letter set and the current player's current hand.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "Timer.h"
#import "GameViewControllerDelegate.h"
@protocol GameManagerDelegate;
@class Player;


static NSInteger const BaseScore = 50;

@interface GameManager : NSObject <TimerDelegate, GameViewControllerDelegate> {
    __weak id <GameManagerDelegate> _delegate; // Initialize delegate
}

@property (nonatomic, strong) NSMutableSet *wordsUsed;
@property (nonatomic, strong) Player *myPlayer;
@property (nonatomic, strong) Timer *timer;
@property (nonatomic, strong) NSMutableArray *currentHand;
@property (nonatomic, strong) Firebase *firebase;
@property (nonatomic) NSInteger shuffleCount;

- (instancetype) initWithMyPlayer:(Player *)myPlayer
                     otherPlayers:(NSArray *)players
                         delegate:(id)delegate NS_DESIGNATED_INITIALIZER;
- (void)updateEverythingByAddingWord:(NSString *)word
                                from:(NSString *)from
                                  to:(NSString *)to;
+ (NSInteger)maxHand;
- (NSArray *)scores;
- (NSArray *)players;
- (void)refillHand;
- (void)shuffleHandAndSubtract:(BOOL)subtract;
- (BOOL)checkWord:(NSString *)word;
- (BOOL)possibleWord:(NSMutableArray *)letters
                word:(NSString *)word;
- (BOOL) checkDictionaryForWord:(NSString *)word;
- (BOOL) checkWordHasNotBeenUsed:(NSString *)word;

@end
