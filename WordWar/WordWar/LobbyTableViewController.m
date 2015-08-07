//
//  LobbyTableViewController.m
//  WordWar
//
//  Created by Zareen Choudhury on 7/14/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "LobbyTableViewController.h"
#import "GameLobbyViewController.h"
#import "LobbyCell.h"
#import "GameView.h"

@interface LobbyTableViewController ()
@property (nonatomic, copy) NSString *selectedRoom;
@property (nonatomic, copy) NSString *selectedId;
@property (nonatomic, strong) NSMutableArray *roomIds;
@property (nonatomic, strong) NSMutableArray *roomNames;
@property (nonatomic, weak) GameLobbyViewController *joinRoomTarget;
@property (nonatomic, strong) IBOutlet UITableView *tbView;
@end

@implementation LobbyTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.roomNames = [[NSMutableArray alloc] init];
        self.roomIds = [[NSMutableArray alloc] init];
        
        // Initializes table view
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGRect tableViewFrame = CGRectMake(0, 0, width-50, (height/2) + 100);
        self.tbView = [[UITableView alloc] initWithFrame:tableViewFrame];
        self.tableView = self.tbView;
        self.tableView.center = CGPointMake(width/2,height/2);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.tbView.backgroundView = nil;
    self.tbView.backgroundColor = [UIColor purpleColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Getters (public)
- (NSString *)getSelectedRoom {
    return self.selectedRoom;
}

- (NSString *)getSelectedId {
    return self.selectedId;
}

- (NSArray *)getRoomNames {
    return self.roomNames;
}

#pragma mark -
#pragma mark Setters (public)

- (void)updateGameRoomList:(NSArray *)names roomIds:(NSArray *)ids {
    self.roomIds = (NSMutableArray *)ids;
    self.roomNames = (NSMutableArray *)names;
    [self.tableView reloadData];
}

- (void)setJoinRoomTarget:(GameLobbyViewController *)target {
    _joinRoomTarget = target;
}

#pragma mark -
#pragma mark Child view controller
-(void)willMoveToParentViewController:(UIViewController *)parent {
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"Moving to or from parent view controller");
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"Did move to parent view controller");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.backgroundColor = [UIColor clearColor];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView registerClass:[LobbyCell class] forCellReuseIdentifier:@"GameCell"];
    LobbyCell *cell = (LobbyCell *)[self.tableView dequeueReusableCellWithIdentifier:@"GameCell" forIndexPath:indexPath];
    if (cell == nil || ![cell isKindOfClass:LobbyCell.class]) {
        NSLog(@"Creating new cell");
        cell = [[LobbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GameCell"];
    }
    NSLog(@"In cellforRow: %@",self.roomNames[indexPath.row]);
    cell.roomName = self.roomNames[indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:SMALL_FONT size:18]];
    cell.selectionStyle = nil;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.width * 0.23333;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedId = self.roomIds[indexPath.row];
    self.selectedRoom = self.roomNames[indexPath.row];
    
    self.tableView.userInteractionEnabled = NO;
    
    [self.joinRoomTarget joinGame];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.roomNames count];
}

@end
