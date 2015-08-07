//
//  GameRoom.m
//  WordWar
//
//  Created by Zareen Choudhury on 7/13/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "GameRoom.h"
#import "Parse/PFObject+Subclass.h"

@implementation GameRoom
@dynamic playerNames;
@dynamic playerIds;
@dynamic roomName;
@dynamic status;
@dynamic pictures;
@dynamic playerObjects;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"GameRoom";
}

@end
