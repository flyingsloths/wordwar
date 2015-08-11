//
//  ParsePlayer.h
//  WordWar
//
//  Created by Flying Sloths on 7/27/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ParsePlayer : PFObject<PFSubclassing>

@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, copy) NSString *playerId;
@property (nonatomic, strong) PFFile *picture;

@end
