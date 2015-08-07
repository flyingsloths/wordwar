//
//  RoomViewController.h
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RoomView.h"
#import "RoomManager.h"
#import "RoomManagerDelegate.h"
@class RoomManager;
@protocol RoomViewControllerDelegate;

@interface RoomViewController : UIViewController <RoomViewDelegate, RoomManagerDelegate>
@property RoomManager *roomManager;
@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

- (instancetype)initWithGameRoom:(GameRoom *)gameRoom
                      facebookId:(NSString *)fbId;
- (void)setGameRoom:(GameRoom *)gameRoom;
- (void)setFacebookId:(NSString *)fbId;

@end


