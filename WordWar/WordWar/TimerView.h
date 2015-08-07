//
//  TimerView.h
//  WordWar
//
//  Created by Christine Lee on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerView : UIView

- (void)setTimerText:(NSString *)timerText
            timeLeft:(CGFloat)timeLeft;

+ (UIColor *)backgroundColor;
+ (UIColor *)progressColor;

@end