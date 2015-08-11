//
//  WaitingRoomView.h
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol WaitingRoomViewDelegate <NSObject>

@required
- (void)readyButtonPressed;

@end

@interface WaitingRoomView : UIView

@end
