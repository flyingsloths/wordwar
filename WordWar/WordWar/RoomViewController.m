//
//  RoomViewController.m
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/16/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomManager.h"
#import "RoomManagerDelegate.h"
#import "GameViewController.h"
#import "RoomTableViewController.h"
#import "Player.h"
#import "ParsePlayer.h"


@interface  RoomViewController () {
    __weak id <RoomViewControllerDelegate> _delegate;
}
@property (nonatomic, strong) RoomView *roomView;
@property (nonatomic, strong) RoomTableViewController *tableViewController;
@property (nonatomic, strong) NSMutableArray *players;
@end

@implementation RoomViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        RoomManager *manager = [[RoomManager alloc] init];
        _delegate = manager;
    }
    return self;
}

- (instancetype)initWithGameRoom:(GameRoom *)gameRoom facebookId:(NSString *)fbId {
    self = [super init];
    if (self) {
        RoomManager *manager = [[RoomManager alloc] initWithGameRoom:gameRoom delegate:self facebookId:fbId];
        _delegate = manager;
    }
    return self;
}

- (void)loadView {
    self.view = [[RoomView alloc] initWithRoomName:[_delegate getTitle]
                                         delegate:self];
    self.roomView = (RoomView *)self.view;
    self.tableViewController = [[RoomTableViewController alloc] initWithPlayers:_players];
    [self.roomView setTableView:self.tableViewController.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Setters
- (void)setGameRoom:(GameRoom *)gameRoom {
    self.roomManager.gameRoom = gameRoom;
}

- (void)setFacebookId:(NSString *)fbId {
    self.roomManager.myId = fbId;
}


#pragma mark - 
#pragma mark RoomViewDelegate
- (void)readyClicked {
    [_delegate readyClicked];
}

- (void)leaveRoom {
    NSLog(@"In view controller");
    [_delegate leaveRoom];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)updatePlayers:(NSMutableArray *)players {
    NSLog(@"In room view controller.");
    NSMutableArray *playerNames = [NSMutableArray array];
    for (Player *player in players) {
        [playerNames addObject:player.realName];
    }
    [self.tableViewController updatePlayersList:playerNames];
    if(playerNames.count > 1)
        [self.roomView showReady:YES];
    else
        [self.roomView showReady:NO];
    
}

- (void)startGame:(GameRoom *)gameRoom
             myID:(NSString *)myID {
    NSLog(@"Game Room in RoomViewController: %@", gameRoom.description);
    GameViewController *gameViewController = [[GameViewController alloc] initWithGameRoom:gameRoom
                                                                                     myID:myID];
    [self.backgroundMusic stop];
    self.backgroundMusic = nil;
    [self presentViewController:gameViewController
                       animated:YES
                     completion:nil];
}

@end
