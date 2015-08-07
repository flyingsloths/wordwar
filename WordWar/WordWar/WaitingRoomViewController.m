//
//  WaitingRoomViewController.m
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/14/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "WaitingRoomViewController.h"
#import "WaitingRoomView.h"

@interface WaitingRoomViewController ()

@property (nonatomic, strong) WaitingRoomView *waitingRoomView;

@end

@implementation WaitingRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark WaitingRoomViewDelegate functions
- (void)readyButtonPressed {
    [_delegate readyButtonPressed];
}

#pragma mark -
#pragma mark WaitingRoomManagerDelegate functions
- (void)

@end
