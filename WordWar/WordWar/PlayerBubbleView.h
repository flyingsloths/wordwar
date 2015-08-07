//
//  PlayerBubbleView.h
//  WordWar
//
//  Created by Christine Lee on 7/14/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
@class Player;

@interface PlayerBubbleView : UIImageView

@property (nonatomic, weak) Player* player;
@property (nonatomic) CGFloat radius;
@property (nonatomic, strong) POPSpringAnimation *radiusAnimation;

- (instancetype)initWithPlayer:(Player *)player
                    isMyPlayer:(BOOL)isMyPlayer NS_DESIGNATED_INITIALIZER;
+ (CGFloat)radius;
- (void)performContractionAnimation;
- (void)updateRank;
- (void)updateScore;
- (void)setProfilePicture:(UIImage *)profilePic;

@end
