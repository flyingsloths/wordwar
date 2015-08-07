//
//  GameLobbyView.h
//  WordWar
//
//  Created by Christine Lee on 7/8/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
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
