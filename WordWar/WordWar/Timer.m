//
//  GameTimer.m
//  WordWar
//
//  Created by Flying Sloths on 7/7/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "Timer.h"

@implementation Timer

- (instancetype)initWithTotalMinutes:(NSInteger)minutes
                        totalSeconds:(NSInteger)seconds
                             delegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _totalMinutes = minutes + seconds/60;
        _totalSeconds = seconds % 60;
        _currentMinute = _totalMinutes;
        _currentSecond = _totalSeconds;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [_delegate timerUpdated:[NSString stringWithFormat:@"%ld:%02ld",self.currentMinute,self.currentSecond]
                       timeLeft:1.0];
    }
    return self;
}

- (void)timerFired {
    NSString *timerText;
    CGFloat timeLeft;
    
    // End of timer
    if ((self.currentMinute == 0) && (self.currentSecond == 1)) {
        timerText = @"Time up!!";
        timeLeft = 0;
    } else {
        
        //text for the timer
        self.currentSecond = (self.currentSecond + 59) % 60; //+59 to avoid negatives
        if (self.currentSecond == 59) self.currentMinute--;
        timerText = [NSString stringWithFormat:@"%ld:%02ld",
                     self.currentMinute,self.currentSecond];
        
        //ratio of time left
        NSInteger currentTotalSeconds = [self timeInSecondsWithMinutes:self.currentMinute seconds:self.currentSecond];
        NSInteger totalSeconds = [self timeInSecondsWithMinutes:self.totalMinutes seconds:self.totalSeconds];
        timeLeft = currentTotalSeconds / (CGFloat)totalSeconds;
    }
    [_delegate timerUpdated:timerText
                   timeLeft:timeLeft];
}

- (NSInteger)timeInSecondsWithMinutes:(NSInteger)minutes
                              seconds:(NSInteger)seconds {
    return minutes*60 + seconds;
}

@end
