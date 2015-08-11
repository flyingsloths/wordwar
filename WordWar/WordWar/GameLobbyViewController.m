//
//  GameLobbyViewController.m
//  WordWar
//
//  Created by Flying Sloths on 7/8/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GameLobbyViewController.h"
#import "GameLobbyView.h"
#import "GameLobbyManager.h"
#import "GameLobbyViewControllerDelegate.h"
#import "LobbyTableViewController.h"
#import "LoginViewController.h"
#import "GameRoom.h"
#import "RoomManager.h"
#import "RoomViewControllerDelegate.h"
#import "RoomViewController.h"
#import "Player.h"
#import "ParsePlayer.h"

@interface GameLobbyViewController () {
    __weak id <GameLobbyViewControllerDelegate> _delegate;
}
@property (nonatomic, strong) GameLobbyView *gameLobbyView;
@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, strong) RoomViewController *roomViewController;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *fbId;
@property (nonatomic, strong) UIImage *profilePicture;

@end

@implementation GameLobbyViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"GLVC init");
        _gameLobbyManager = [[GameLobbyManager alloc] initWithDelegate:self];
        _delegate = _gameLobbyManager;
        
        // Background music
        NSError *error;
        NSURL *castleTheme = [[NSBundle mainBundle] URLForResource:@"castletheme"
                                                     withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:castleTheme
                                                             error:&error];
        if (error)
            NSLog(@"error loading background theme, %@",error);
        
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic play];
    }
    return self;
}

- (void)viewDidLoad {
    self.view = [[GameLobbyView alloc] initWithDelegate:self];
    self.gameLobbyView = (GameLobbyView *)self.view;
    
    // Add table view controller as child view controller
    self.tableViewController = [[LobbyTableViewController alloc] init];
    [self.tableViewController setJoinRoomTarget:self];
    [self addChildViewController:self.tableViewController];
    [self.tableViewController didMoveToParentViewController:self];
    
    // Add table view as subview of lobby view
    [self.gameLobbyView setTableView:(UITableView *)self.tableViewController.view];
    
    // Query Parse to initialize game list with current game rooms
    [_delegate updateGameList];
    
//    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    // Facebook login displayed if needed
    if ([FBSDKAccessToken currentAccessToken]) {
        if (!self.userName) {
            [self fetchUserInfo];
        }
    } else {
        // Never logged in yet, present login button
        self.loginViewController = [[LoginViewController alloc] initWithDelegate:self];
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        [self presentViewController:self.loginViewController animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchUserInfo {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Username and ID
            self.userName = result[@"name"];
            self.fbId = result[@"id"];
            NSLog(@"%@ has FB ID %@", self.userName, self.fbId);
            
            // Profile picture
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",self.fbId]];
            NSData  *data = [NSData dataWithContentsOfURL:url];
            self.profilePicture = [UIImage imageWithData:data];
        }
    }];
}

- (BOOL)isDuplicateRoom:(NSString *)room {
    NSArray *roomNames = self.tableViewController.roomNames;
    return ([roomNames containsObject:room]);
}

- (void)stopSpinner {
    [self.gameLobbyView stopSpinner];
}

#pragma mark -
#pragma mark FBSDKLoginButtonDelegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil) {
        [self fetchUserInfo]; // after user logs in, gets their info
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark LobbyViewDelegate
- (void)joinGame {
    [self.gameLobbyView startSpinner];
    [self joinGameWithId:self.tableViewController.selectedId];
}

- (void)joinGameWithId:(NSString *)roomId {
    __weak GameLobbyViewController *weakSelf = self;
    
    // Creates Player
    Player *myPlayer = [[Player alloc] initWithID:self.fbId realName:self.userName playerIndex:-1 baseScore:50 profilePic:self.profilePicture];
    [_delegate joinGameWithName:roomId
                         player:myPlayer
                      withBlock:^(GameRoom *gameRoom){
                          RoomViewController *roomViewController = [[RoomViewController alloc] initWithGameRoom:gameRoom facebookId:self.fbId];
                          [self.gameLobbyView stopSpinner];

                          roomViewController.backgroundMusic = self.backgroundMusic;

                          [weakSelf presentViewController:roomViewController animated:YES completion:nil];
                      }];
    
    //allow clicks again after creating
    self.tableViewController.tableView.userInteractionEnabled = YES;
}

- (void)createGame {
    
    // Alert for inputting game room name
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Room" message:@"Enter game room name" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak GameLobbyViewController *weakSelf = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        NSString *text = textField.text;
        
        //unique room name
        if ([self isDuplicateRoom:text]) {
            UIAlertController *duplicateAlert =
                [UIAlertController alertControllerWithTitle:@"Name used already"
                                                    message:@"Please enter a new name."
                                             preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
            [duplicateAlert addAction:done];
            
            [weakSelf presentViewController:duplicateAlert
                                   animated:YES
                                 completion:nil];
        
        //null string
        } else if (text.length < 1) {
            UIAlertController *nullAlert = [UIAlertController alertControllerWithTitle:@"No text entered" message:@"Please enter a new name" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [nullAlert addAction:done];
            [weakSelf presentViewController:nullAlert animated:YES completion:nil];
            
        //short enough room name
        } else if (text.length > 23) {
            UIAlertController *lengthyNameAlert =
                [UIAlertController alertControllerWithTitle:@"Name too long (>23 char)"
                                                    message:@"Please enter a new name"
                                             preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *done = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
            [lengthyNameAlert addAction:done];
            
            [weakSelf presentViewController:lengthyNameAlert
                                   animated:YES
                                 completion:nil];
        
        //present room
        } else {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self.gameLobbyView startSpinner];
            [_delegate createGameWithName:text];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Game room name";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark LobbyManagerDelegate

- (void)updateGameList:(NSArray *)gameRoomList roomIds:(NSArray *)roomIds {
    [self.tableViewController updateGameRoomList:gameRoomList roomIds:roomIds];
}

@end
