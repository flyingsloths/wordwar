//
//  EndGameView.h
//  WordWar
//
//  Created by Flying Sloths on 7/22/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Player;

@protocol EndGameViewDelegate <NSObject>

@required
- (void)leaveToLobby;

@end

@interface EndGameView : UIView

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                         players:(NSArray *)players
                        delegate:(id<EndGameViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;
+ (CGFloat)radiusForRank:(NSInteger)rank;

@end