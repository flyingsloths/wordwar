//
//  GameLobbyView.h
//  WordWar
//
//  Created by Flying Sloths on 7/8/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameLobbyViewDelegate <NSObject>
@required
- (void)createGame;
- (void)joinGame;
@end

@interface GameLobbyView : UIView 
- (instancetype)initWithDelegate:(id)delegate;
- (void)setTableView:(UITableView *)tableView;
- (UITableView *)getTableView;
- (void)startSpinner;
- (void)stopSpinner;

@end
