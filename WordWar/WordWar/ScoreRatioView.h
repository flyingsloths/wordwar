//
//  ScoreRatio.h
//  WordWar
//
//  Created by Flying Sloths on 7/20/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Player;

@interface ScoreRatioView : UIView

@property (nonatomic, copy) NSArray *ratios;

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                         players:(NSArray *)players NS_DESIGNATED_INITIALIZER;

@end
