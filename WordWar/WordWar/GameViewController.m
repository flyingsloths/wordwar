//
//  GameViewController.m
//  WordWar
//
//  Created by Christine Lee on 7/2/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "GameViewController.h"
#import "Player.h"
#import "Timer.h"
#import "GameView.h"
#import "GameManager.h"
#import "GameManagerDelegate.h"
#import "GameViewControllerDelegate.h"
#import "GameRoom.h"
#import "EndGameViewController.h"
#import <Parse/Parse.h>
#import "ParsePlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface GameViewController ()

@property (nonatomic, strong) GameView *gameView;
@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

@end

@implementation GameViewController

- (instancetype)initWithGameRoom:(GameRoom *)gameRoom
                            myID:(NSString *)myID {
    
    self.gameRoom = gameRoom;
    NSLog(@"Game Room in GameViewController: %@", gameRoom.description);
    
    // Convert ParsePlayer to Player
    NSMutableArray *players = [[NSMutableArray alloc] init];
    Player *myPlayer;
    for (ParsePlayer *parsePlayer in gameRoom.playerObjects) {
        Player *newPlayer = [[Player alloc] initWithID:parsePlayer.playerId realName:parsePlayer.playerName playerIndex:[players count] baseScore:50 profilePic:nil];

        // Get picture
        PFFile *pictureFile = parsePlayer.picture;
        [pictureFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                // TODO: Set profile picture through game manager and view
                newPlayer.profilePic = image;
            }
        }];
        
        if ([parsePlayer.playerId isEqualToString:myID]) {
            newPlayer.playerIndex = -1;
            myPlayer = newPlayer;
        } else {
            [players addObject:newPlayer];
        }
    }
    
    // Initialize game manager
    _gameManager = [[GameManager alloc] initWithMyPlayer:myPlayer
                                            otherPlayers:[players copy]
                                                delegate:self];
    self.view = [[GameView alloc] initWithMyPlayer:myPlayer
                                      otherPlayers:[players copy]
                                          delegate:self];
    self.gameView = (GameView *)self.view;
    _delegate = _gameManager;
    [self updateShuffleCount:self.gameManager.shuffleCount];

    [_delegate initializeFirebase:gameRoom.objectId];
    
    //Background Music
    NSError *error;
    NSURL *happyTheme = [[NSBundle mainBundle] URLForResource:@"happygametheme"
                                                 withExtension:@"mp3"];
    _backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:happyTheme
                                                              error:&error];
    if (error)
        NSLog(@"error loading game background theme, %@",error);
  
    _backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic play];

    return self;
}

- (void)loadView {
    
}

- (void)viewDidLoad {
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

#pragma mark -
#pragma mark Gestures
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event {
    //shake to shuffle iff game is in session
    if ([_delegate inSession] && motion == UIEventSubtypeMotionShake) {
        [self.gameView clearWordCreationView];
        [_delegate shuffleHandAndSubtract:YES];
    }
}

#pragma mark -
#pragma mark System Functions
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark GameViewDelegate functions
- (void)countdownFinished {
    [_delegate restartGame];
}

- (void)submitWord:(NSString *)word
                to:(NSString *)to {
    [_delegate submitWord:word to:to];
}

- (BOOL)checkDictionaryForWord:(NSString *)word {
    return [self.gameManager checkDictionaryForWord:word];
}

- (BOOL)checkWordHasNotBeenUsed:(NSString *)word {
    return [self.gameManager checkWordHasNotBeenUsed:word];
}

#pragma mark -
#pragma mark GameManagerDelegate
- (void)setMessageText:(NSString *)message
       messageType:(NSString *)messageType
    affectedPlayer:(Player *)affectedPlayer
     sendingPlayer:(Player *)sendingPlayer {
    [self.gameView setMessageText:message
                      messageType:messageType
                   affectedPlayer:affectedPlayer
                    sendingPlayer:sendingPlayer];
}

- (void)toggleFreeze {
    [self.gameView toggleFreeze];
}

- (void)updateShuffleCount:(NSInteger)myShuffleCount {
    [self.gameView setShuffleCount:myShuffleCount];
}

- (void)updateHandView:(NSArray *)hand {
    [self.gameView setHand:hand];
}

- (void)toggleHide {
    [self.gameView toggleHide];
}

- (void)setTime:(NSString *)timeText
       timeLeft:(CGFloat)timeLeft{
    [self.gameView setTimerText:timeText
                       timeLeft:timeLeft];
    
    if ([timeText isEqualToString:@"Time up!!"]) {
        [self.gameView toggleFreeze]; //TODO
        [self.gameView destroyBomb];
    }
}

- (void)clearWordCreationView {
    [self.gameView clearWordCreationView];
}

- (BOOL)checkWord:(NSString *)word {
    return [self.gameManager checkWord:word];
}

- (void)endGame {
    //freeze everything so you nothing can be done
    [self resignFirstResponder];            //can't shake the screen
    [self.gameView toggleFreeze];           //freeze everything
    [self.gameView toggleHide];             //hide everything
    [self.gameView destroyBomb];            //no word being thrown
    [self.gameView destroyCatapult];        //no catapult
    [self.gameView setHand:nil];            //nothing in hand
    [self.gameView clearWordCreationView];  //no word being made
    [self.gameView destroyMessageTexts];    //no messages to appear
    [self.gameView destroyWordViews];       //nothing to tap on, so placeholder bug is gone
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.backgroundColor = [UIColor clearColor];
    endLabel.text = @"Game over!";
    endLabel.font = [UIFont fontWithName:BIG_FONT size:30];
    [endLabel sizeToFit];
    endLabel.center = self.gameView.center;
    [self.gameView addSubview:endLabel];
    
    __block GameViewController *weakSelf = self;
    //after two seconds to allow for any remaining messages to come in, display the end game screen
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*2),dispatch_get_main_queue(),^{
        EndGameViewController *endGameVC = [[EndGameViewController alloc] initWithMyPlayer:self.gameManager.myPlayer
                                                                                   players:self.gameManager.players];
        endGameVC.backgroundMusic = self.backgroundMusic;
        [weakSelf presentViewController:endGameVC animated:YES completion:nil];
        [_delegate deleteGame:self.gameRoom];
    });
}

- (void)updateRatios:(NSArray *)ratios {
    [self.gameView setRatios:ratios];
}

- (void)updateRanks {
    [self.gameView setRanks];
}

- (void)updateScores {
    [self.gameView setScores];
}

@end
