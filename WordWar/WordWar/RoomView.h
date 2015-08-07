//
//  RoomView.h
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol RoomViewDelegate <NSObject> // Initialize delegate

@required
- (void)readyClicked;
- (void)leaveRoom;

@end

@interface RoomView : UIView

- (instancetype)initWithRoomName:(NSString *)roomName
                       delegate:(id<RoomViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;
- (void)setTableView:(UITableView *)tableView;
- (UITableView *)getTableView;
- (void)showReady:(BOOL)show;

@end
