//
//  TimerView.h
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView

- (void)setTimerText:(NSString *)timerText
            timeLeft:(CGFloat)timeLeft;

+ (UIColor *)backgroundColor;
+ (UIColor *)progressColor;

@end