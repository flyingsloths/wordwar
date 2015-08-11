//
//  WordBomb.m
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "WordBomb.h"
#import <pop/POP.h>
#import "NSStringScrabbleExtension.h"
#import "UIImage+animatedGIF.h"
#import "GameView.h"

@interface WordBomb ()

@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UILabel *pointsLabel;

@end

@implementation WordBomb

- (instancetype)initWithWord:(NSString *)word {
    self = [super init];
    if  (self) {
        _word = word;
        
        //word label
        _wordLabel = [[UILabel alloc] init];
        _wordLabel.textAlignment = NSTextAlignmentCenter;
        _wordLabel.text = word;
        _wordLabel.textColor = [UIColor whiteColor];
        _wordLabel.font = [UIFont fontWithName:SMALL_FONT size:24];
        [_wordLabel sizeToFit];
        
        CGRect frame = self.frame;
        frame.size.width = _wordLabel.bounds.size.width+50;
        frame.size.height = frame.size.width;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        NSURL *bombURL = [[NSBundle mainBundle] URLForResource:@"bomb" withExtension:@"gif"];
        self.image = [UIImage animatedImageWithAnimatedGIFURL:bombURL];
        _wordLabel.center = CGPointMake(self.bounds.size.width*0.45,self.bounds.size.height/2);
        
        [self addSubview:_wordLabel];
        
        //points label
        _points = [word scrabblePoints];
        _pointsLabel = [[UILabel alloc] init];
        _pointsLabel.textAlignment = NSTextAlignmentCenter;
        _pointsLabel.text = [NSString stringWithFormat:@"%ld",_points];
        _pointsLabel.textColor = [UIColor whiteColor];
        _pointsLabel.font = [UIFont fontWithName:SMALL_FONT size:18];
        _pointsLabel.frame = CGRectMake(self.bounds.size.width*3/5,self.bounds.size.height*3/5,0,0);
        [_pointsLabel sizeToFit];
        [self addSubview:_pointsLabel];
        
        _catapultOrigin = CGPointMake(-100,-100); //negative means there is none
    }
    return self;
}

- (BOOL)hasOrigin {
    return !(self.catapultOrigin.x < 0 || self.catapultOrigin.y < 0);
}

@end