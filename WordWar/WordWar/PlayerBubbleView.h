//
//  PlayerBubbleView.h
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
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
