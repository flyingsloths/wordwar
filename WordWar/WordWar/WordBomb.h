//
//  WordBomb.h
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>


@interface WordBomb : UIImageView

@property (nonatomic, copy) NSString *word;
@property (nonatomic) NSInteger points;
@property (nonatomic) CGPoint catapultOrigin; //for view to use

- (instancetype)initWithWord:(NSString *)word NS_DESIGNATED_INITIALIZER;
- (BOOL)hasOrigin;

@end
