//
//  WaitingRoomViewController.h
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingRoomView.h"
#import "WaitingRoomManager.h"
@protocol WaitingRoomViewControllerDelegate;
@class WaitingRoomManager;

@protocol WaitingRoomViewControllerDelegate <NSObject>

@required
- (void)updatePlayersList;

@end

@interface WaitingRoomViewController : UIViewController <WaitingRoomViewDelegate, WaitingRoomMangerDelegate>
{
    __weak id<WaitingRoomViewControllerDelegate> _delegate;
}

@end
