//
//  RoomTableViewController.m
//  WordWar
//
//  Created by Flying Sloths on 7/22/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "RoomTableViewController.h"
#import "Player.h"
#import "ParsePlayer.h"
#import "GameView.h"
#import "RoomCell.h"

@interface RoomTableViewController ()
@property (nonatomic, copy) NSString *selectedRoom;
@property (nonatomic, copy) NSString *selectedId;
@property (nonatomic, strong) NSMutableArray *playerIds;
@property (nonatomic, strong) NSMutableArray *playerNames;
@property (nonatomic, strong) IBOutlet UITableView *tbView;

@end

@implementation RoomTableViewController

- (instancetype)initWithPlayers:(NSMutableArray *)players {
    self = [super init];
    if (self) {
        self.playerNames = [[NSMutableArray alloc] init];
        for (ParsePlayer *player in players) {
            [self.playerNames addObject:player.playerName];
        }
        
        // Initializes table view
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGRect tableViewFrame = CGRectMake(50, 100, width-100, (height/2) + 100);
        self.tbView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView = self.tbView;
        self.tableView.center = CGPointMake(width/2,height/2);
        self.tableView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tbView.backgroundView = nil;
    self.tbView.backgroundColor = [UIColor purpleColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark Setters (public)

- (void)updatePlayersList:(NSMutableArray *)players {
    self.playerNames = players;
    NSLog(@"In table view. Players: %@", self.playerNames);
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.backgroundColor = [UIColor clearColor];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playerNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView registerClass:[RoomCell class] forCellReuseIdentifier:@"PlayerCell"];
    RoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
    if (cell == nil || ![cell isKindOfClass:RoomCell.class]) {
        NSLog(@"Creating new cell");
        cell = [[RoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayerCell"];
    }
    cell.playerName = self.playerNames[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.width * 0.23333;
}


@end
