//
//  Player.h
//  WordWar
//
//  Created by Flying Sloths on 7/6/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//
//  Player is a combination of things that everyone knows (i.e. things that the
//  server will send to everyone).
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PlayerBubbleView;

@interface Player : NSObject

@property (nonatomic, copy) NSString *fbID;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger rank;
@property (nonatomic) NSInteger playerIndex;
@property (nonatomic, strong) UIImage *profilePic;
@property (nonatomic, strong) PlayerBubbleView *bubbleView;

- (instancetype)initWithID:(NSString *)playerID
                  realName:(NSString *)realName
               playerIndex:(NSInteger)playerIndex
                 baseScore:(NSInteger)score
                profilePic:(UIImage *)image NS_DESIGNATED_INITIALIZER;
- (UIColor *)color;

@end
