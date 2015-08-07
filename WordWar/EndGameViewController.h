//
//  EndGameViewController.h
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/27/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Player.h"
#import "EndGameView.h"

@interface EndGameViewController : UIViewController <EndGameViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                         players:(NSArray *)players;

@end
