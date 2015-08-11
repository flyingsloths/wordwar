//
//  GameViewController.h
//  WordWar
//
//  Created by Flying Sloths on 7/2/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "GameView.h"
#import "GameManagerDelegate.h"
#import "GameRoom.h"
@protocol GameViewControllerDelegate;
@class GameManager;

static NSString * const MessageTypeWordSent = @"word";
static NSString * const MessageTypeNoMoreShuffles = @"shuffles";
static NSString * const MessageTypeTimerNotification = @"timer";

@interface GameViewController : UIViewController <GameViewDelegate,GameManagerDelegate>
{
    __weak id<GameViewControllerDelegate> _delegate;
}

@property (nonatomic, strong) NSString* testString;
@property (nonatomic, strong) GameManager *gameManager;
@property (nonatomic) NSInteger currentMinute;
@property (nonatomic) NSInteger currentSecond;
@property (nonatomic, strong) GameRoom *gameRoom;

- (instancetype)initWithGameRoom:(GameRoom *)gameRoom
                            myID:(NSString *)myID;

@end