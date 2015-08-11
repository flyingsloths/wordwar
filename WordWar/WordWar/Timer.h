//
//  GameTimer.h
//  WordWar
//
//  Created by Flying Sloths on 7/7/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//
//  Countdown timer starting at the specified time
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TimerDelegate <NSObject>
@required
- (void)timerUpdated:(NSString *)timeText
            timeLeft:(CGFloat)timeLeft;
@end


@interface Timer : NSObject {
    __weak id <TimerDelegate> _delegate;
}

@property (nonatomic) NSInteger totalMinutes;
@property (nonatomic) NSInteger totalSeconds;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentMinute;
@property (nonatomic) NSInteger currentSecond;

- (instancetype)initWithTotalMinutes:(NSInteger)minutes
                        totalSeconds:(NSInteger)seconds
                            delegate:(id)delegate NS_DESIGNATED_INITIALIZER;
- (void)timerFired;

@end
