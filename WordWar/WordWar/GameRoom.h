//
//  GameRoom.h
//  WordWar
//
//  Created by Flying Sloths on 7/13/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GameRoom : PFObject<PFSubclassing>

@property (nonatomic, strong) NSMutableArray *playerNames; //real names
@property (nonatomic, strong) NSMutableArray *playerIds; //fbIDs
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSMutableArray *playerObjects;
+ (NSString *)parseClassName;

@end
