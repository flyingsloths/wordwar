//
//  Player.m
//  WordWar
//
//  Created by Christine Lee on 7/6/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "Player.h"
#import "PlayerBubbleView.h"

@implementation Player

#pragma mark Initializers
//have to set the letter set count outside
- (instancetype)initWithID:(NSString *)playerID
                  realName:(NSString *)realName
               playerIndex:(NSInteger)playerIndex
                 baseScore:(NSInteger)score
                profilePic:(UIImage *)image {
    self = [super init];
    if (self) {
        _fbID = playerID;
        _realName = realName;
        _playerIndex = playerIndex;
        _score = score;
        if (image)
            _profilePic = image;
        else
            _profilePic = self.temporaryImage;
        _rank = 1;
    }
    return self;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"<Player %@, #%ld, Score: %ld>",
                      self.fbID,self.playerIndex,self.score];
    return desc;
}

- (void)setProfilePic:(UIImage *)profilePic {
    _profilePic = profilePic;
    
    if (self.bubbleView)
       [self.bubbleView setProfilePicture:profilePic];
}

- (UIColor *)color {
    switch(self.playerIndex) {
        case -1: //my player
            //green-ish
            return [UIColor colorWithRed:104.0/255
                                   green:129.0/255
                                    blue:104.0/255
                                   alpha:1];
        case 0:
            //blue-ish
            return [UIColor colorWithRed:86.0/255
                                   green:146.0/255
                                    blue:175.0/255
                                   alpha:1.0];
        case 1:
            //purple-ish
            return [UIColor colorWithRed:195.0/255
                                   green:156.0/255
                                    blue:235.0/255
                                   alpha:1.0];
        default:
            //orange-ish
            return [UIColor colorWithRed:230.0/255
                                   green:185.0/255
                                    blue:120.0/255
                                   alpha:1.0];
    }
}

- (UIImage *)temporaryImage {
    NSString *imageFile = [NSString stringWithFormat:@"sloth%ld",self.playerIndex];
    return [UIImage imageNamed:[imageFile stringByAppendingString:@".jpg"]];
}

@end
