
//  GameManager.m
//  WordWar
//
//  Created by Flying Sloths on 7/6/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "GameManager.h"
#import "GameRoom.h"
#import "GameViewController.h"
#import "GameManagerDelegate.h"
#import "Player.h"
#import "NSStringScrabbleExtension.h"
#import "RoomManager.h"
#import <AudioToolBox/AudioToolbox.h>


static NSInteger const MaxHand = 9;
static NSInteger const StartNumShuffles = 5;
NSDictionary *letterValues = nil;

@interface GameManager ()

@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, copy) NSSet *dictionary;

@end

@implementation GameManager

#pragma mark -
#pragma mark Initializers and Description
- (instancetype)initWithMyPlayer:(Player *)myPlayer
                    otherPlayers:(NSArray *)players
                        delegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _myPlayer = myPlayer;
        _players = [players mutableCopy];
        [self initializeDictionary];
        
        _shuffleCount = StartNumShuffles;
    }
    return self;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"<%@, Hand: %@, Players: %@>",
                      self.myPlayer,self.currentHand,self.players];
    return desc;
}

#pragma mark -
#pragma mark Getters and Setters
+ (NSInteger)maxHand {
    return MaxHand;
}

- (NSArray *)players {
    return _players.copy;
}

- (NSArray *)scores {
    NSMutableArray *scores = [NSMutableArray array];
    for (Player *player in self.players) {
        [scores addObject:[[NSNumber alloc] initWithInteger:player.score]];
    }
    return scores.copy;
}

- (NSArray *)ratios {
    NSMutableArray *ratios = [NSMutableArray array];
    float ratio = 0;
    // Add my ratio, which is always 1
    [ratios addObject:[NSNumber numberWithFloat:(1.0)]];
    ratio = (float)_myPlayer.score/((float)BaseScore * (self.players.count + 1));
    
    // For all other ratios
    for(Player *player in self.players) {
        CGFloat playerRatio = ratio + ((float)player.score/(float)(BaseScore * (self.players.count + 1)));
        [ratios addObject:[NSNumber numberWithFloat:(1 - ratio)]];
        ratio = playerRatio;
    }
    return [ratios copy];
}

#pragma mark -
#pragma mark Sender
- (BOOL)checkWord:(NSString *)word {
    return ![word isEqualToString:@""] &&
            [self checkWordHasNotBeenUsed:word] &&
            [self checkDictionaryForWord:word];
}

// Checks if word is in English dictionary
- (BOOL) checkDictionaryForWord:(NSString *)word {
    return [_dictionary containsObject:word];
}

// Checks if word has been played already in the game
- (BOOL) checkWordHasNotBeenUsed:(NSString *)word {
    if ([self.wordsUsed containsObject:word]) return NO;
    return YES;
}

- (void)initializeDictionary {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"eng-dict"
                                                         ofType:@"txt"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    
    if (error) NSLog(@"Error reading file: %@", error.localizedDescription);
    
    //put in a set so checking for existence is easy
    NSArray *dictionaryArray = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    _dictionary = [NSSet setWithArray:dictionaryArray];
    
    //only words with more than 2 letters
    NSPredicate *moreThan2 = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *word = evaluatedObject;
        return word.length > 2;
    }];
    _dictionary = [_dictionary filteredSetUsingPredicate:moreThan2];
}

#pragma mark -
#pragma mark Receiver
- (void)updateEverythingByAddingWord:(NSString *)word
                                from:(NSString *)from
                                  to:(NSString *)to {
    //add word to words that have been used
    [self.wordsUsed addObject:word];
    
    //update scores
    [self updateScoresWithWord:word
                          from:from
                            to:to];
    [_delegate updateRatios:self.ratios];
    
    //update rankings
    [self updateRankings];
    [_delegate updateRanks];
    [_delegate updateScores];
    
    if ([self.myPlayer.fbID isEqualToString:from]) {
        [self removeWordFromHand:word];
        //only refill if you sent word
        [self refillHand];
    }
}

- (void)updateRankings {
    NSMutableArray *allPlayers = self.players.mutableCopy;
    [allPlayers addObject:self.myPlayer];
    
    //Order players by ranking
    NSSortDescriptor *rankSorter = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES];
    [allPlayers sortUsingDescriptors:@[rankSorter]];
    
    //Assign ranks
    NSInteger rank = 1;
    Player *firstPlayer = [allPlayers objectAtIndex:0];
    firstPlayer.rank = rank;
    for(int i = 1; i < allPlayers.count; i++) {
        Player *prevPlayer = [allPlayers objectAtIndex:i - 1];
        Player *currPlayer = [allPlayers objectAtIndex:i];
        if (currPlayer.score == prevPlayer.score) {
            currPlayer.rank = rank;
            continue;
        } else {
            rank = i+1;
            currPlayer.rank = rank;
        }
    }
}

- (void)removeWordFromHand:(NSString *)word {
    for (int i = 0; i < word.length; i++) {
        NSString *letter = [word substringWithRange:NSMakeRange(i, 1)];
        for (NSString *character in _currentHand) {
            if ([character isEqualToString:letter]) {
                [_currentHand removeObjectIdenticalTo:character];
                break;
            }
        }
    }
}

- (void)refillHand {
    while (_currentHand.count < MaxHand) {
        NSString *letter = [self randomLetter];
        [_currentHand addObject:letter];
    }
    
    //TODO: ??? is there a better solution to this
    
//    NSMutableString *word = [NSMutableString stringWithString:@""];
//    if (![self possibleWord:_currentHand.mutableCopy
//                       word:word]) {
//        [self shuffleHandAndSubtract:NO];
//    }
    [_delegate updateHandView:self.currentHand];
}

- (BOOL)possibleWord:(NSMutableArray *)letters
                word:(NSMutableString *)word {
    //if word has already been used, not a possible word
    if (![self checkWordHasNotBeenUsed:word])
        return NO;
    //if word is a valid word, then it is a possible word
    if ([self checkDictionaryForWord:word])
        return YES;
    //modify the word
    for (int i = 0; i < letters.count - 1; i++) {
        NSString *chosenLetter = [letters objectAtIndex:i];
        [letters removeObjectAtIndex:i];
        [word appendString:chosenLetter];
        if([self possibleWord:letters word:word])
            return YES;
        word = [[word substringToIndex:word.length - 2] mutableCopy];
        [letters insertObject:chosenLetter atIndex:i];
    }
    return NO;
}

- (void)updateScoresWithWord:(NSString *)word
                        from:(NSString *)from
                          to:(NSString *)to {
    NSArray *players = self.players;
    NSInteger score = [word scrabblePoints];
    
    // Removes from sender
    if ([self.myPlayer.fbID isEqualToString:from])
        self.myPlayer.score -= score;
    else {
        for (Player *player in players) {
            if ([player.fbID isEqualToString:from])
                player.score -= score;
        }
    }
    
    // Adds to receiver
    if ([self.myPlayer.fbID isEqualToString:to]) {
        self.myPlayer.score += score;
        
        if (score >= 10)
            [GameView playShortSound:@"boom" extension:@"wav"];
    }
    else {
        for (Player *player in players) {
            if ([player.fbID isEqualToString:to])
                player.score += score;
        }
    }
}

- (void)restartGame {
    _currentHand = [NSMutableArray array];
    _wordsUsed = [NSMutableSet set];
    
    for (Player *player in self.players) {
        player.score = BaseScore;
    }
    
    [self refillHand];
    [_delegate updateRatios:self.ratios];
    [_delegate updateHandView:self.currentHand.copy];
    
    _timer = [[Timer alloc] initWithTotalMinutes:1 totalSeconds:30 delegate:self];
    [_delegate toggleFreeze];
    [_delegate toggleHide];
}

- (NSString *)randomLetter {
    /* FREQUENCY TABLE FOR EACH LETTER IN ALPHABET */
    NSArray *frequencyTable = @[@10,@12,@14,@18,@30,@32,@35,@37,@46,
                                @47,@48,@52,@54,@60,@68,@70,@71,@77,
                                @82,@88,@92,@94,@96,@97,@99,@100];
    int randomNum = arc4random_uniform(101);
    int indexInAlphabet;
    while (true) {
        if([frequencyTable containsObject:[NSNumber numberWithInteger:randomNum]]) {
            indexInAlphabet = (int)[frequencyTable indexOfObject:[NSNumber numberWithInteger:randomNum]];
            break;
        }
        randomNum++;
    }
    
    NSString *letter = [NSString stringWithFormat:@"%c",indexInAlphabet + 97];
    return letter;
}

#pragma mark -
#pragma mark GameViewControllerDelegate
- (void)initializeFirebase:(NSString *)gameID {
    
    self.firebase = [[Firebase alloc] initWithUrl:[[FIREBASE_URL stringByAppendingString:gameID] stringByAppendingString:@"game"]];
    NSLog(@"Firebase Game ID: %@", [[FIREBASE_URL stringByAppendingString:gameID] stringByAppendingString:@"game"]);
    Firebase *nullRef = [self.firebase childByAutoId];
    [nullRef setValue:[NSNull null]];
    
    //Firebase Delegate Code
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSString *word, *from, *to;
        
        if (snapshot != (FDataSnapshot *)[NSNull null]) {
            
            //Only respond if there is a value (account for null)
            id receivedDictionary = snapshot.value;
            from =[receivedDictionary objectForKey:@"from"];
            to = [receivedDictionary objectForKey:@"to"];
            word = [receivedDictionary objectForKey:@"word"];
            
            
            if (from && to && word) {
                //Word was received
                Player *affectedPlayer;
                Player *sendingPlayer;
                for (Player *player in self.players) {
                    if ([player.fbID isEqualToString:to]) {
                        affectedPlayer = player;
                        continue;
                    }
                    if ([player.fbID isEqualToString:from]) {
                        sendingPlayer = player;
                        continue;
                    }
                }
                if (!affectedPlayer) affectedPlayer = self.myPlayer;
                if (!sendingPlayer) sendingPlayer = self.myPlayer;
                
                NSString *sendingFirstName = [sendingPlayer.realName componentsSeparatedByString:@" "].firstObject;
                NSString *receivingFirstName = [affectedPlayer.realName componentsSeparatedByString:@" "].firstObject;
                
                NSString *message = [NSString stringWithFormat:@"%@ sent %@ to %@",
                                     sendingFirstName,word,receivingFirstName ];
                [_delegate setMessageText:message
                              messageType:MessageTypeWordSent
                           affectedPlayer:affectedPlayer
                            sendingPlayer:sendingPlayer];
                [self updateEverythingByAddingWord:word
                                              from:from
                                                to:to];
                NSLog(@"message %@",message);
            }
        }
    }];
}

- (void)submitWord:(NSString *)word
                to:(NSString *)to {
    if ([self checkWord:word]) {
        Firebase *wordRef = [self.firebase childByAutoId];
        [wordRef setValue:@{ @"word":word,
                             @"to":to,
                             @"from" : self.myPlayer.fbID}];
        [_delegate clearWordCreationView];
    }
}

- (void)shuffleHandAndSubtract:(BOOL)subtract {
    if(_shuffleCount > 0) {
        [_currentHand removeAllObjects];

        [self refillHand];
        if (subtract) {
            _shuffleCount--;
            [_delegate updateShuffleCount:_shuffleCount];
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    } else {
        [_delegate setMessageText:@"No more shuffles available"
                      messageType:MessageTypeNoMoreShuffles
                   affectedPlayer:nil
                    sendingPlayer:nil];
    }
}

- (BOOL)inSession{
    //if GM has a timer, then the game is in session
    return (self.timer != nil);
}

- (void)deleteGame:(GameRoom *)gameRoom {
    NSLog(@"In delete game");
    PFQuery *query = [PFQuery queryWithClassName:@"GameRoom"];
    [query getObjectInBackgroundWithId:gameRoom.objectId block:^(PFObject *retrievedGameRoom, NSError *error) {
        [retrievedGameRoom deleteInBackground];
    }];

}

#pragma mark -
#pragma mark TimerDelegate
- (void)timerUpdated:(NSString *)timeText
            timeLeft:(CGFloat)timeLeft{
    if ([timeText isEqualToString:@"Time up!!"]) {
        if ([timeText isEqualToString:@"Time up!!"]) {
            [self.timer.timer invalidate];
            self.timer = nil;
        }
        Firebase *nullRef = [self.firebase childByAutoId];
        [nullRef setValue:[NSNull null]];
        
        [_delegate endGame];
    } else {
        if ([timeText isEqualToString:@"0:10"]) [_delegate setMessageText:@"10 seconds left!"
                                                              messageType:MessageTypeTimerNotification
                                                           affectedPlayer:nil
                                                            sendingPlayer:nil];
        [_delegate setTime:timeText
                  timeLeft:timeLeft];
    }
}

@end
