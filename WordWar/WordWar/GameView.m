//
//  GameView.m
//  WordWar
//
//  Created by Flying Sloths on 7/8/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <pop/POP.h>
#import "GameView.h"
#import "Player.h"
#import "LetterPiece.h"
#import "LetterView.h"
#import "GameViewController.h"
#import "GameManager.h"
#import "PlayerBubbleView.h"
#import "TimerView.h"
#import "ScoreRatioView.h"
#import "EndGameView.h"

@interface GameView () {
    __weak id <GameViewDelegate> _delegate;
}


/// Game Information ///
@property (nonatomic) NSInteger myPlayerIndex; //index of player
@property (nonatomic, strong) Player *myPlayer;
@property (nonatomic, copy) NSArray *players;
@property (nonatomic, strong) WordBomb *wordBomb; //to be sent to another player

/// Buttons ///
@property (nonatomic, strong) NSMutableArray *playerBubbles;
@property (nonatomic, strong) IBOutlet PlayerBubbleView *myPlayerBubble;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) IBOutlet UIButton *backspaceButton;

/// Text Views ///
@property (nonatomic, strong) IBOutlet ScoreRatioView *scoreView;
@property (nonatomic, strong) IBOutlet UILabel *shuffleCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *wordMessageView;
@property (nonatomic, strong) IBOutlet UILabel *creationMessageView;
@property (nonatomic, strong) IBOutlet TimerView *timerView;
@property (nonatomic, strong) IBOutlet UIView *catapultView; //representation of catapult origin

/// Text Fields & Selection Fields ///
@property (nonatomic, strong) IBOutlet LetterView *wordCreationView;
@property (nonatomic, strong) IBOutlet LetterView *handView;

/// Fixes ///
@property (nonatomic, strong) IBOutlet UIView *cover;

@end

@implementation GameView

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                    otherPlayers:(NSArray *)players
                        delegate:(id<GameViewDelegate>)delegate {
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        
        /*********************
         * PLAYER INFO SETUP *
         *********************/
        _myPlayer = myPlayer;
        _players = players;
        
        /**************
         * VIEW SETUP *
         **************/
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.frame = frame;
        self.layer.contents = (id)[UIImage imageNamed:@"gamebg"].CGImage;
        
        /// PLAYER BUBBLES ///
        _playerBubbles = [NSMutableArray array];
        for (int i = 0; i < _players.count; i++) {
            Player *currentPlayer = (Player *)_players[i];
            CGPoint center = [GameView centerForPlayerBubbleWithIndex:i
                                                      numberOfPlayers:self.players.count
                                                        widthOfScreen:[UIScreen mainScreen].bounds.size.width];
            PlayerBubbleView *playerBubble = [[PlayerBubbleView alloc] initWithPlayer:currentPlayer
                                                                           isMyPlayer:NO];
            playerBubble.center = center;
            playerBubble.userInteractionEnabled = NO;
            playerBubble.hidden = YES;
            currentPlayer.bubbleView = playerBubble;
            [_playerBubbles addObject:playerBubble];
        }
        
        /// MY PLAYER BUBBLE ///
        _myPlayerBubble = [[PlayerBubbleView alloc] initWithPlayer:_myPlayer isMyPlayer:YES];
        _myPlayerBubble.center = CGPointMake(_myPlayerBubble.bounds.size.width/2-10,
                                             self.bounds.size.height-_myPlayerBubble.bounds.size.height/2+10);
        _myPlayer.bubbleView = _myPlayerBubble;
        _myPlayerBubble.userInteractionEnabled = NO;
        _myPlayerBubble.hidden = YES;

        /// SHUFFLE COUNT ///
        _shuffleCountLabel = [[UILabel alloc] init];
        _shuffleCountLabel.backgroundColor = [UIColor clearColor];
        _shuffleCountLabel.font = [UIFont fontWithName:BIG_FONT size:20];
        [_shuffleCountLabel sizeToFit];
        _shuffleCountLabel.hidden = YES;
        
        NSInteger letterCapacity = [GameManager maxHand];
        
        /// HAND VIEW ///
        _handView = [[LetterView alloc] initWithLetterCapacity:letterCapacity
                                                   bufferWidth:5
                                                  bufferHeight:5
                                                          rows:2
                                                       columns:5
                                              letterSideLength:55
                                                  cornerRadius:7
                                                  placeholders:YES];
        [_handView setTapGestureTarget:self action:@selector(handViewToWordView:)];
        _handView.center = CGPointMake(width/2, height-_handView.bounds.size.height/2-100);
        _handView.hidden = YES;
        _handView.userInteractionEnabled = NO;
        
        
        /// WORD CREATION VIEW ///
        _wordCreationView = [[LetterView alloc] initWithLetterCapacity:letterCapacity
                                                           bufferWidth:0
                                                          bufferHeight:10
                                                                  rows:1
                                                               columns:9
                                                      letterSideLength:38
                                                          cornerRadius:2
                                                          placeholders:NO];
        _wordCreationView.center = CGPointMake(width/2, _handView.frame.origin.y-_wordCreationView.bounds.size.height/2-60);
        _wordCreationView.hidden = YES;
        _wordCreationView.userInteractionEnabled = NO;
        
        /// SCORE RATIO VIEW ///
        _scoreView = [[ScoreRatioView alloc] initWithMyPlayer:_myPlayer
                                                      players:_players];
        PlayerBubbleView *firstBubble = self.playerBubbles.firstObject;
        CGFloat originY = firstBubble.frame.origin.y+firstBubble.frame.size.height+10;
        _scoreView.frame =
            CGRectMake(0,originY,20,height-self.myPlayerBubble.frame.size.height-originY);
        _scoreView.hidden = YES;
        
        /// BACKSPACE BUTTON ///
        _backspaceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _backspaceButton.userInteractionEnabled = YES;  //at beginning, there are no letters, so the backspace
        _backspaceButton.alpha = 0.4;                   //should not be activated
        _backspaceButton.hidden = YES;
        CGRect backspaceFrame = _backspaceButton.frame;
        backspaceFrame.size.width = 70;
        backspaceFrame.size.height += backspaceFrame.size.width*0.43089;
        _backspaceButton.frame = backspaceFrame;
        _backspaceButton.center =
            CGPointMake(width-_backspaceButton.bounds.size.width,
                        _wordCreationView.frame.origin.y+_wordCreationView.bounds.size.height+15);
        _backspaceButton.layer.contents = (id)[UIImage imageNamed:@"deletebutton"].CGImage;
        
        /// TIMER VIEW ///
        CGPoint timerCenter = CGPointMake(width*.88,height*.935);
        _timerView = [[TimerView alloc] init];
        _timerView.center = timerCenter;
        _timerView.hidden = YES;
        
        /// WORD MESSAGE VIEW ///
        CGRect messageFrame = CGRectMake(0,0, width*3/4, 30);
        _wordMessageView = [[UILabel alloc] initWithFrame:messageFrame];
        _wordMessageView.center = CGPointMake(width/2,230);
        _wordMessageView.textColor = [UIColor whiteColor];
        [_wordMessageView setFont:[UIFont fontWithName:SMALL_FONT size:22]];
        _wordMessageView.clipsToBounds = YES;
        _wordMessageView.layer.cornerRadius = 10;
        _wordMessageView.textAlignment = NSTextAlignmentCenter;
        _wordMessageView.layer.opacity = 0;
        
        /// CREATION MESSAGE VIEW ///
        _creationMessageView = [[UILabel alloc] init];
        _creationMessageView.backgroundColor = [UIColor darkGrayColor];
        _creationMessageView.textColor = [UIColor whiteColor];
        [_creationMessageView setFont:[UIFont fontWithName:SMALL_FONT size:22]];
        _creationMessageView.clipsToBounds = YES;
        _creationMessageView.layer.cornerRadius = 10;
        _creationMessageView.textAlignment = NSTextAlignmentCenter;
        _creationMessageView.layer.opacity = 0;
        _creationMessageView.frame = CGRectMake(0,0,width*3/4,30);
        _creationMessageView.center = CGPointMake(width/2, _wordCreationView.frame.origin.y-_creationMessageView.frame.size.height/2-10);
        
        /* Put everything together */
        [self addSubview:_wordCreationView];
        [self addSubview:_handView];
        [self addSubview:_timerView];
        [self addSubview:_wordMessageView];
        [self addSubview:_scoreView];
        [self addSubview:_shuffleCountLabel];
        [self addSubview:_creationMessageView];
        [self addSubview:_myPlayerBubble];
        for (UIButton *button in _playerBubbles) [self addSubview:button];
        
        /***********************
         * TARGET-ACTION PAIRS *
         ***********************/
        /// Backspace ///
        [self.backspaceButton addTarget:self
                                 action:@selector(backspacePressed:)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.backspaceButton addTarget:self
                                 action:@selector(holdDownBackspace:)
                       forControlEvents:UIControlEventTouchDown];
        
        /***********************
         * GESTURE RECOGNIZERS *
         ***********************/
        /// COVER TO FIX PAN GESTURE ///
        _cover = [[UIView alloc] initWithFrame:_wordCreationView.frame];
        _cover.backgroundColor = [UIColor clearColor];
        [self addSubview:_cover];
        [self insertSubview:_backspaceButton aboveSubview:_cover];
        _wordCreationView.cover = _cover;
        
        UIPanGestureRecognizer *dragToFormWord =
            [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(dragWordBomb:)];
        [_cover addGestureRecognizer:dragToFormWord];
        
        UITapGestureRecognizer *letterFromWordView =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tappedOnWordCreationView:)];
        [_cover addGestureRecognizer:letterFromWordView];
        
        [self startGame];
    }
    return self;
}

#pragma mark -
#pragma mark Setters (public)
- (void)setShuffleCount:(NSInteger)shuffleCount {
    _shuffleCount = shuffleCount;
    [self updateShuffleCount];
}

- (void)setTimerText:(NSString *)timerText
            timeLeft:(CGFloat)timeLeft {
    [self.timerView setTimerText:timerText
                        timeLeft:timeLeft];
}

- (void)setRatios:(NSArray *)ratios {
    self.scoreView.ratios = ratios;
}

- (void)setRanks {
    for (PlayerBubbleView *bubble in self.playerBubbles) {
        [bubble updateRank];
    }
    [self.myPlayerBubble updateRank];
}

- (void)setScores {
    for (PlayerBubbleView *bubble in self.playerBubbles) {
        [bubble updateScore];
    }
    [self.myPlayerBubble updateScore];
}

#pragma mark -
#pragma mark Player Bubbles
+ (CGPoint)centerForPlayerBubbleWithIndex:(NSInteger)index
                          numberOfPlayers:(NSInteger)playerCount
                            widthOfScreen:(CGFloat)width {
    CGFloat diameter = [PlayerBubbleView radius]*2;
    CGFloat y = diameter/2 + 20; //+20 because of the status bar
    CGFloat x;
    //even
    if (playerCount % 2 == 0) {
        //want the midpoints
        switch(index) {
            case 0:
                x = 0.7*(diameter/4+width/4) + 0.3*(diameter/2);
                break;
            default:
                x = 0.7*(width*3/4-diameter/4) + 0.3*(width-diameter/2);
        }
        //odd
    } else {
        //if center, stay there
        if (index == playerCount / 2) {
            x = width/2;
        } else {
            CGFloat buffer = 20;
            //if not center, then there must be 3 players
            switch(index) {
                case 0:
                    x = diameter/2 + buffer;
                    break;
                default: //should be 2
                    x = width-diameter/2 - buffer;
                    break;
            }
        }
    }
    return CGPointMake(x, y);
}

#pragma mark -
#pragma mark MessageView
- (void)setMessageText:(NSString *)messageText
           messageType:(NSString *)messageType
        affectedPlayer:(Player *)player
         sendingPlayer:(Player *)sendingPlayer {
    self.wordMessageView.text = messageText;
    
    //set color of the message view to denote what kind of message it is
    if ([messageType isEqualToString:MessageTypeNoMoreShuffles]) {
        self.wordMessageView.backgroundColor = [UIColor darkGrayColor];
    } else if ([messageType isEqualToString:MessageTypeTimerNotification]) {
        self.wordMessageView.backgroundColor = [UIColor lightGrayColor];
    } else if ([messageType isEqualToString:MessageTypeWordSent]) {
        self.wordMessageView.backgroundColor = player.color;
        //animate player bubble to contract (receiver)
        if (sendingPlayer != self.myPlayer)
            [player.bubbleView performContractionAnimation];
    }
    
    if (![messageText isEqualToString:@""]) {
        [self performMessageViewAnimationOnView:self.wordMessageView showing:YES];
    }
}

- (void)setCreationMessageText:(NSString *)messageText {
    self.creationMessageView.text = messageText;
    [self performMessageViewAnimationOnView:self.creationMessageView
                                    showing:YES];
}

- (void)performMessageViewAnimationOnView:(UILabel *)messageView
                                  showing:(BOOL)show {
    CALayer *layer = messageView.layer;
    
    [layer pop_removeAllAnimations];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animation.fromValue = @(show ? 0 : 1);
    animation.toValue = @(show ? 1 : 0);
    animation.velocity = @(10);
    
    GameView *weakSelf = self;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        //wait a bit to allow for the shown MessageView to display, before animating the fade
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.85*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (show) {
                [weakSelf performMessageViewAnimationOnView:messageView showing:NO];
            }
        });
    };
    
    [layer pop_addAnimation:animation forKey:@"animation"];
}


#pragma mark -
#pragma mark Updates (private)
- (void)updateShuffleCount {
    NSString *shuffleCountText =[NSString stringWithFormat:@"Shuffles: %ld",(long)_shuffleCount];
    self.shuffleCountLabel.text = shuffleCountText;
    [self.shuffleCountLabel sizeToFit];
    self.shuffleCountLabel.center = CGPointMake(self.bounds.size.width/2,
                                                self.bounds.size.height-_shuffleCountLabel.frame.size.height/2-10);
}

- (void)toggleFreeze {
    for (UIButton *button in self.playerBubbles) {
        button.userInteractionEnabled = !button.userInteractionEnabled;
    }
    self.handView.userInteractionEnabled = !self.handView.userInteractionEnabled;
    self.wordCreationView.userInteractionEnabled = !self.wordCreationView.userInteractionEnabled;
    self.backspaceButton.userInteractionEnabled = !self.backspaceButton.userInteractionEnabled;
}

- (void)toggleHide {
    for (UIButton *button in self.playerBubbles) button.hidden = !button.hidden;
    self.shuffleCountLabel.hidden = !self.shuffleCountLabel.hidden;
    self.handView.hidden = !self.handView.hidden;
    self.wordCreationView.hidden = !self.wordCreationView.hidden;
    self.timerView.hidden = !self.timerView.hidden;
    self.scoreView.hidden = !self.scoreView.hidden;
    self.backspaceButton.hidden = !self.backspaceButton.hidden;
    self.myPlayerBubble.hidden = !self.myPlayerBubble.hidden;
}

- (void)destroyBomb {
    [self.wordBomb removeFromSuperview];
    self.wordBomb = nil;
}

- (void)destroyCatapult {
    [self.catapultView removeFromSuperview];
    self.catapultView = nil;
    self.wordBomb.catapultOrigin = CGPointMake(-100,-100);
}

- (void)destroyWordViews {
    [self.handView removeFromSuperview];
    self.handView = nil;
    [self.wordCreationView removeFromSuperview];
    self.wordCreationView = nil;
}

- (void)destroyMessageTexts {
    [self.wordMessageView removeFromSuperview];
    self.wordMessageView = nil;
    [self.creationMessageView removeFromSuperview];
    self.creationMessageView = nil;
}

- (void)clearWordCreationView {
    while (self.wordCreationView.letters.count > 0) {
        LetterPiece *piece = self.wordCreationView.letters.firstObject;
        [self.wordCreationView removeLetterPiece:piece];
        [piece removeFromSuperview];
    }
    self.backspaceButton.userInteractionEnabled = NO;
    self.backspaceButton.alpha = 0.4;
}

- (void)startGame {
    //instantiate label
    UILabel *countdown = [[UILabel alloc] init];
    countdown.backgroundColor = [UIColor clearColor];
    countdown.font = [UIFont fontWithName:BIG_FONT size:40];
    countdown.text = @"3";
    countdown.layer.opacity = 0;
    [countdown sizeToFit];
    countdown.center = self.center;
    [self addSubview:countdown];
    
    //countdown
    __weak GameView *weakSelf = self;
    POPSpringAnimation *fadeIn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    fadeIn.fromValue = @(0);
    fadeIn.toValue = @(1);
    fadeIn.velocity = @(5);
    fadeIn.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [countdown.layer pop_removeAllAnimations];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*1),dispatch_get_main_queue(),^{
            countdown.text = @"2";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*1),dispatch_get_main_queue(),^{
                countdown.text = @"1";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*1),dispatch_get_main_queue(),^{
                    countdown.text = @"GO!";
                    [countdown sizeToFit];
                    countdown.center = weakSelf.center;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*1),dispatch_get_main_queue(),^{
                        [_delegate countdownFinished];
                        POPSpringAnimation *fadeOut = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                        fadeOut.fromValue = @(1);
                        fadeOut.toValue = @(0);
                        fadeOut.velocity = @(-5);
                        fadeOut.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                            [countdown.layer pop_removeAllAnimations];
                            [countdown removeFromSuperview];
                        };
                        [countdown.layer pop_addAnimation:fadeOut forKey:@"fadeout"];
                    });
                });
            });
        });
    };
    [countdown.layer pop_addAnimation:fadeIn forKey:@"fadein"];
    
    //show everything in the view
}

#pragma mark -
#pragma mark Actions
- (void)playerSubmitButtonPressed:(id)sender {
    NSString *word = self.wordCreationView.wordCreated;
    [_delegate submitWord:word to:((UIButton *)sender).titleLabel.text];
}

- (BOOL)checkWord:(NSString *)word {
    return [_delegate checkWord:word];
}

#pragma mark -
#pragma mark Adding/Removing Letters
- (void)setHand:(NSArray *)hand {
    //TODO: offscreen point should be piggy bank
    CGPoint offScreenPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height+200);
    if (hand.count <= self.handView.capacity) {
        __weak GameView *weakSelf = self;
        
        if (_hand.count > 0) {
            __block CGFloat seconds = 0.0;
            
            //remove all letters from hand
            for (LetterPiece *piece in self.handView.letters) {
                //removal animation, fade out
                POPSpringAnimation *fadeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
                fadeAnimation.fromValue = @(1);
                fadeAnimation.toValue = @(0);
                fadeAnimation.velocity = @(-10);
                fadeAnimation.completionBlock = ^(POPAnimation *anim,BOOL finished) {
                    [piece removeFromSuperview];
                    [piece.layer pop_removeAnimationForKey:@"fade"];
                };
                [piece.layer pop_addAnimation:fadeAnimation forKey:@"fade"];
            }
            [self.handView.letters removeAllObjects];
            
            //animate new letters on
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.5), dispatch_get_main_queue(), ^{
                seconds = 0.0;
                //set the rest of the pieces
                for (int i = 0; i < hand.count; i++) {
                    LetterPiece *piece = [weakSelf.handView pieceFromLetter:(NSString *)hand[i]];
                    [weakSelf.handView addLetter:piece atIndex:i fromView:nil];
                    CGPoint toPoint = [weakSelf.handView centerForLetterAtIndex:i];
                    piece.center = offScreenPoint;
                    CGPoint velocity = CGPointMake((toPoint.x-offScreenPoint.x)/3,(toPoint.y-offScreenPoint.y)/3);
                    
                    //addition animation, fly onto screens
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,NSEC_PER_SEC*seconds),dispatch_get_main_queue(),^{
                        [GameView playShortSound:@"whoosh" extension:@"wav"];
                        [piece performTranslationAnimationTo:toPoint
                                                    velocity:velocity
                                                  completion:nil];
                    });
                    seconds += 0.05;
                }
            });
        }
        _hand = hand;
    }
}

// Puts the selected letter into the view
- (void)handViewToWordView:(UIGestureRecognizer *)recognizer {
    NSLog(@"hello????");
    LetterPiece *piece = (LetterPiece *)recognizer.view;
    if (!piece.isPlaceholder && !self.wordCreationView.isFull && piece.container == self.handView) {
        
        CGPoint fromPoint = piece.center;
        
        [self.wordCreationView addLetter:piece
                                 atIndex:self.wordCreationView.letters.count
                                fromView:self.handView];
        [self.wordCreationView centerView];
        [self.wordCreationView setIsWord];
        
        CGPoint toPoint = [self.wordCreationView centerForLetterAtIndex:piece.index];
        CGPoint velocity = CGPointMake(toPoint.x-fromPoint.x,toPoint.y-fromPoint.y);
        piece.center = fromPoint;
        
        [GameView playShortSound:@"whoosh" extension:@"wav"];
        [piece performTranslationAnimationTo:toPoint
                                    velocity:velocity
                                  completion:nil];
        
        //a letter was just added, so we can enable the backspace again
        if (!self.backspaceButton.userInteractionEnabled) {
            self.backspaceButton.userInteractionEnabled = YES;
            self.backspaceButton.alpha = 1.0;
        }
    }
}

- (void)backspacePressed:(id)sender {
    LetterPiece *piece = self.wordCreationView.letters.lastObject;
    UIButton *button = sender;
    
    button.alpha = 1.0;
    
    [self wordViewToHandView:piece];
}

- (void)holdDownBackspace:(id)sender {
    UIButton *button = sender;
    
    button.alpha = 0.8;
}

- (void)tappedOnWordCreationView:(UIGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    CGPoint position = [recognizer locationInView:tappedView];
    position.x += tappedView.frame.origin.x;
    position.y += tappedView.frame.origin.y;
    
    for (LetterPiece *piece in self.wordCreationView.letters) {
        CGFloat distance = [self distanceBetween:piece.center and:position];
        if (distance <= self.wordCreationView.pieceLength/2) {
            [self wordViewToHandView:piece];
            return;
        }
    }
}

- (void)wordViewToHandView:(LetterPiece *)piece {
    CGPoint fromPoint = piece.center;
    piece.image = [LetterPiece defaultLetterImage];
    
    [self.handView addLetter:piece
                     atIndex:self.handView.firstIndexOfPlaceholder
                    fromView:self.wordCreationView];
    [self.wordCreationView centerView];
    [self.wordCreationView setIsWord];
    
    CGPoint toPoint = [self.handView centerForLetterAtIndex:piece.index];
    CGPoint velocity = CGPointMake(toPoint.x-fromPoint.x,toPoint.y-fromPoint.y);
    
    piece.center = fromPoint;
    
    [self insertSubview:piece belowSubview:self.cover]; //to be seen
    [GameView playShortSound:@"whoosh" extension:@"wav"];
    [piece performTranslationAnimationTo:toPoint
                                velocity:velocity
                              completion:nil];
    
    //no more letters to remove, disable the backspace button
    if ([self.wordCreationView.wordCreated isEqualToString:@""]) {
        self.backspaceButton.userInteractionEnabled = NO;
        self.backspaceButton.alpha = 0.4;
    }
}

#pragma mark -
#pragma mark WordBomb
- (void)dragWordBomb:(UIPanGestureRecognizer *)recognizer {
    //must have a WordBomb to throw around, or have a word to turn into one
    
    if (self.wordBomb || self.wordCreationView.isWord) {
        
        if ([recognizer.view isKindOfClass:[LetterPiece class]]) {
            self.wordCreationView.gestureRecognizers = @[recognizer];
        }
        
        /// GESTURE ENDED, THROW THE BOMB ///
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint velocity;
            //do a catapult action if there is a catapult point, or toss upwards
            if (self.wordBomb.hasOrigin)
                velocity = CGPointMake(self.wordBomb.catapultOrigin.x - self.wordBomb.center.x,
                                       self.wordBomb.catapultOrigin.y - self.wordBomb.center.y);
            else
                velocity = [recognizer velocityInView:self];
            CGPoint destination = [self directionOfThrownBomb:velocity];
            __block GameView *weakSelf = self;
            [self performBombAnimationTo:destination
                            withVelocity:velocity
                              completion:^(POPAnimation *anim, BOOL finished) {
                                  [weakSelf centerChangedTo:weakSelf.wordBomb.center];
                              }];
            if (self.catapultView) [self destroyCatapult];
            return;
        }
        /// IN MOTION ///
        CGPoint velocity = [recognizer velocityInView:self];
        CGPoint position = [recognizer locationInView:self];
        
        if (!self.wordBomb) {
            //turn word into a word bomb
            NSString *word = self.wordCreationView.wordCreated;
            [self clearWordCreationView];
            self.wordBomb = [[WordBomb alloc] initWithWord:word];
            self.wordBomb.center = [recognizer locationInView:self];
            [self addSubview:self.wordBomb];
            
            //play the sound
            [GameView playShortSound:@"bubblecreate" extension:@"wav"];
        }
        
        //pull down, rubberband effect
        if (self.wordBomb.hasOrigin) {
            CGPoint origin = self.wordBomb.catapultOrigin;
            CGPoint newPoint = CGPointMake(0.35*position.x+0.65*origin.x,
                                           0.35*position.y+0.65*origin.y);
            newPoint.y = newPoint.y < origin.y+15 ? origin.y+15 : newPoint.y;
            self.wordBomb.center = newPoint;
            return;
        
        //moving up, do not allow higher than the player bubbles
        } else if (velocity.y < 0) {
            CGFloat minY = ((PlayerBubbleView *)self.playerBubbles.firstObject).center.y;
            CGPoint newPoint = position;
            if (position.y < minY) newPoint.y = minY;
            self.wordBomb.center = newPoint;
            return;

        //moving down, add catapult visual representation
        } else {
            self.wordBomb.catapultOrigin = position;
            self.catapultView = [[UIView alloc] init];
            self.catapultView.frame = CGRectMake(0,0,15,15);
            self.catapultView.layer.cornerRadius = 15.0/2;
            self.catapultView.layer.opacity = 0.50;
            self.catapultView.backgroundColor = [UIColor blackColor];
            self.catapultView.center = position;
            [self addSubview:self.catapultView];
            return;
        }
    }
    
    //user tried to drag, but there is no valid word / word has already been used
    if (recognizer.state == UIGestureRecognizerStateBegan && !self.wordCreationView.isWord) {
        NSString *word = self.wordCreationView.wordCreated;
        if ([word isEqualToString:@""])
            return;
        else if (word.length < 3)
            [self setCreationMessageText:@"Need at least 3 letters!"];
        else if (![_delegate checkWordHasNotBeenUsed:word])
            [self setCreationMessageText:[NSString stringWithFormat:@"%@ has already been used!",word]];
        else
            [self setCreationMessageText:[NSString stringWithFormat:@"%@ is not a word!",word]];
    }
}

- (CGFloat)distanceBetween:(CGPoint)pointA
                       and:(CGPoint)pointB {
    CGFloat xDiff = pointB.x - pointA.x;
    CGFloat yDiff = pointB.y - pointA.y;
    return sqrt(xDiff*xDiff + yDiff*yDiff);
}

+ (void)playShortSound:(NSString *)fileName
             extension:(NSString *)extension {
    SystemSoundID sound;
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:fileName
                                                          ofType:extension];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFile];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFileURL,&sound);
    AudioServicesPlaySystemSound(sound);
}

- (void)performBombAnimationTo:(CGPoint)toPoint
                  withVelocity:(CGPoint)velocity
                    completion:(void (^)(POPAnimation *,BOOL))completion {
    CALayer *layer = self.wordBomb.layer;
    
    [layer pop_removeAllAnimations];
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    animation.fromValue = [NSValue valueWithCGPoint:self.wordBomb.center];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.velocity = [NSValue valueWithCGPoint:velocity];
    animation.completionBlock = completion;
    [layer pop_addAnimation:animation forKey:@"animation"];
}

- (CGPoint)directionOfThrownBomb:(CGPoint)velocity {
    CGFloat velocityY = -1 * velocity.y; //simulate regular axis
    CGFloat theta = atan2f(velocityY,velocity.x); //degrees from horizontal axis
    CGFloat yOnBubbleAxis =
    self.wordBomb.center.y - ((PlayerBubbleView *)self.playerBubbles.firstObject).center.y;
    CGFloat xRelativeToBomb =  yOnBubbleAxis * cos(theta);
    CGFloat xOnBubbleAxis = self.wordBomb.center.x + xRelativeToBomb;
    
    switch (self.playerBubbles.count) {
        case 1:
            return ((PlayerBubbleView *)self.playerBubbles.firstObject).center;
        case 2: {
            if (xOnBubbleAxis < [UIScreen mainScreen].bounds.size.width/2)
                return ((PlayerBubbleView *)self.playerBubbles[0]).center;
            else
                return ((PlayerBubbleView *)self.playerBubbles[1]).center;
        }
        case 3: {
            //give more space to the bubble in the middle because it's the hardest to throw to that one
            CGFloat leftPoint = ((PlayerBubbleView *)self.playerBubbles[0]).center.x;
            CGFloat rightPoint = ((PlayerBubbleView *)self.playerBubbles[2]).center.x;
            
            CGPoint center;
            if (xOnBubbleAxis < leftPoint) center = ((PlayerBubbleView *)self.playerBubbles[0]).center;
            else if (xOnBubbleAxis < rightPoint) center = ((PlayerBubbleView *)self.playerBubbles[1]).center;
            else center = ((PlayerBubbleView *)self.playerBubbles[2]).center;
            return center;
        }
    }
    return CGPointMake(0,0); //should never reach this point
}

- (void)centerChangedTo:(CGPoint)center {
    CGRect bombFrame = self.wordBomb.frame;
    
    for (PlayerBubbleView *bubble in self.playerBubbles) {
        CGRect playerFrame = bubble.frame;
        //hit a player
        if (CGRectIntersectsRect(bombFrame, playerFrame)) {
            //submit word
            [_delegate submitWord:self.wordBomb.word to:bubble.player.fbID];
            [bubble performContractionAnimation]; //to avoid lag between receiving message
            
            //destroy the bomb
            [self destroyBomb];
            
            //play sound
            [GameView playShortSound:@"bubbleabsorb" extension:@"wav"];
            return;
        }
    }
}

@end
