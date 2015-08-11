//
//  ParsePlayer.m
//  WordWar
//
//  Created by Flying Sloths on 7/27/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "ParsePlayer.h"

@implementation ParsePlayer
@dynamic playerName;
@dynamic playerId;
@dynamic picture;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ParsePlayer";
}

@end
