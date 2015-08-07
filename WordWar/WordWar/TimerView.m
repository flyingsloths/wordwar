//
//  TimerView.m
//  WordWar
//
//  Created by Christine Lee on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "TimerView.h"
#import "GameView.h"

@interface TimerView ()

@property (nonatomic, strong) IBOutlet UILabel *timerLabel;
@property (nonatomic) CGFloat timeLeft;

@end

@implementation TimerView

- (instancetype)init {
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0,0,80,80);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        CGRect labelFrame = CGRectMake(0,0, 80, 80);
        _timerLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        [_timerLabel setFont:[UIFont fontWithName:BIG_FONT size:18]];
        _timerLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_timerLabel];
    }
    return self;
}

#pragma mark - 
#pragma mark Setters
- (void)setTimerText:(NSString *)timerText
            timeLeft:(CGFloat)timeLeft {
    _timerLabel.text = timerText;
    _timeLeft = timeLeft;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Drawing
- (void)drawRect:(CGRect)rect {
    [self drawTimerBackground];
    [self drawTimeProgress];
}

- (void)drawTimerBackground {
    CGFloat radius = 25; //for background behind timer
    CGFloat endAngle = 2.0*M_PI; //full circle for this
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:0.0
                                                      endAngle:endAngle
                                                     clockwise:YES];
    path.lineCapStyle = kCGLineCapRound;

    [[TimerView backgroundColor] setFill];
    [path fill];
}

- (void)drawTimeProgress {
    CGFloat radius = 33;
    CGFloat beginTip = 2.0*M_PI*self.timeLeft - (M_PI_2); //retracting as time decreases
    CGFloat endTip = -M_PI_2;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:beginTip
                                                      endAngle:endTip
                                                     clockwise:NO];
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 8;
    
    [[TimerView progressColor] setStroke];
    [path stroke];
}

+ (UIColor *)backgroundColor {
    //peach yellow
    return [UIColor colorWithRed:1.0 green:223.0/255 blue:173.0/255 alpha:1.0];
}

+ (UIColor *)progressColor {
    //spanish orange
    return [UIColor colorWithRed:232.0/255 green:97.0/255 blue:0 alpha:1.0];
}

@end
