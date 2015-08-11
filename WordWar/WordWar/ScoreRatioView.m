//
//  ScoreRatioView.m
//  WordWar
//
//  Created by Flying Sloths on 7/20/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "ScoreRatioView.h"
#import "Player.h"

@interface ScoreRatioView ()

@property (nonatomic, strong) NSMutableArray *playerViews;

@end

@implementation ScoreRatioView

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                         players:(NSArray *)players {
    self = [super init];
    if (self) {
        _playerViews = [NSMutableArray array];
        
        UIView *scoreView = [[UIView alloc] init];
        scoreView.backgroundColor = myPlayer.color;
        [_playerViews addObject:scoreView];
        [self addSubview:scoreView];
        
        for (Player *player in players) {
            scoreView = [[UIView alloc] init];
            scoreView.backgroundColor = player.color;
            [_playerViews addObject:scoreView];
            [self addSubview:scoreView];
        }
    }
    return self;
}

- (void)setRatios:(NSArray *)ratios {
    _ratios = ratios;
    CGFloat selfHeight = self.bounds.size.height;
    NSInteger count = ratios.count;
    
    //TODO: animations
    for (NSInteger i = 0; i < count; i++) {
        CGFloat ratio = ((NSNumber *)ratios[i]).floatValue;
        UIView *view = (UIView *)self.playerViews[i];
        
        CGRect frame = view.frame;
        if (i + 1 >= count) { //last player
            frame.origin.y = 0; //top of score bar
        } else {
            CGFloat nextRatio = ((NSNumber *)ratios[i+1]).floatValue;
            frame.origin.y = nextRatio*selfHeight; //top of view to the bottom
        }
        
        CGFloat height = selfHeight*ratio - frame.origin.y;
        frame.size.height = height;
        
        frame.size.width = self.bounds.size.width;
        frame.origin.x = self.bounds.origin.x;
    
        view.frame = frame;
    }
}

//CAShapeLayer *maskLayer = [CAShapeLayer layer];
//UIBezierPath *roundedPath =
//[UIBezierPath bezierPathWithRoundedRect:maskLayer.bounds
//                      byRoundingCorners:UIRectCornerTopLeft |
// UIRectCornerBottomRight
//                            cornerRadii:CGSizeMake(16.f, 16.f)];
//maskLayer.fillColor = [[UIColor whiteColor] CGColor];
//maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
//maskLayer.path = [roundedPath CGPath];
//
////Don't add masks to layers already in the hierarchy!
//UIView *superview = [self.view superview];
//[self.view removeFromSuperview];
//self.view.layer.mask = maskLayer;
//[superview addSubview:self.view];

@end
