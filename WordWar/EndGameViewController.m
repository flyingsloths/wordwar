//
//  EndGameViewController.m
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/27/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "EndGameViewController.h"
#import "EndGameView.h"
#import "GameLobbyViewController.h"

@interface EndGameViewController ()

@property (nonatomic, strong) EndGameView *endView;

@end

@implementation EndGameViewController

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                         players:(NSArray *)players{
    self = [super init];
    if(self) {
        
        self.view = [[EndGameView alloc] initWithMyPlayer:myPlayer
                                                  players:players
                                                 delegate:self];
        self.endView = (EndGameView *)self.view;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)leaveToLobby {
    NSLog(@"Leave to lobby: View controller");
    [self.backgroundMusic stop];
    self.backgroundMusic = nil;
    GameLobbyViewController *gameLobbyVC = [[GameLobbyViewController alloc] init];
    [self presentViewController:gameLobbyVC
                       animated:YES
                     completion:nil];
}

@end
