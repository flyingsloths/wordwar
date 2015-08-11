//
//  RoomView.m
//  WordWar
//
//  Created by Flying Sloths on 7/16/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "RoomView.h"
#import "GameView.h"
#import "UIImage+animatedGIF.h"

@interface RoomView () {
    __weak id <RoomViewDelegate> _delegate;
}


/// Room Information ///
@property (nonatomic, strong) NSString *roomName;

/// UI Features ///
@property (nonatomic, strong) IBOutlet UIButton *readyButton;
@property (nonatomic, strong) IBOutlet UILabel *roomNameLabel;
@property (nonatomic, strong) IBOutlet UIButton *leaveRoomButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *titleBackground;
@property (nonatomic, strong) UIImageView *leaveRoomBackground;
@property (nonatomic, strong) UIImageView *startWarBackground;
@end

@implementation RoomView

- (instancetype)initWithRoomName:(NSString *)roomName
                       delegate:(id<RoomViewDelegate>)delegate {
    self = [super init];
    if (self) {
                
        _delegate = delegate;
        
        /*******************
         * ROOM INFO SETUP *
         *******************/
        _roomName = roomName;
        
        /**************
         * VIEW SETUP *
         **************/
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.layer.contents = (id)[UIImage imageNamed:@"stonewall2"].CGImage;
        
        /// VIEW ///
        [self setBackgroundColor:[UIColor whiteColor]];
        
        /// TITLE LABEL ///
        _roomNameLabel = [[UILabel alloc] init];
        [_roomNameLabel setFrame:CGRectMake(0, 0, width, 30)];
        CGPoint labelCenter = CGPointMake(width/2, 60);
        [_roomNameLabel setCenter:labelCenter];
        [_roomNameLabel setText:_roomName];
        [_roomNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_roomNameLabel setBackgroundColor:[UIColor clearColor]];
        [_roomNameLabel setFont:[UIFont fontWithName:BIG_FONT size:25]];
        [self addSubview:_roomNameLabel];
        
        /// BACKGROUND FOR TITLE ///
        _titleBackground = [UIImageView new];
        CGRect backgroundFrame = _roomNameLabel.frame;
        backgroundFrame.size.height += 30;
        _titleBackground.frame = backgroundFrame;
        _titleBackground.center = _roomNameLabel.center;
        _titleBackground.image = [UIImage imageNamed:@"signboard"];
        _titleBackground.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_titleBackground];
        
        /// READY BUTTON ///
        _readyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _readyButton.frame = CGRectMake(0,0, 100, 50);
        [_readyButton setTitle:@"Start War" forState:UIControlStateNormal];
        [_readyButton setUserInteractionEnabled:YES];
        [_readyButton.titleLabel setFont:[UIFont fontWithName:BIG_FONT size:15]];
        [_readyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        /// READY BUTTON BACKGROUND ///
        _startWarBackground = [UIImageView new];
        _startWarBackground.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *readyURL = [[NSBundle mainBundle] URLForResource:@"readyboard" withExtension:@"gif"];
        _startWarBackground.image = [UIImage animatedImageWithAnimatedGIFURL:readyURL];
        CGRect readyFrame = _readyButton.frame;
        readyFrame.size.width += 150;
        _startWarBackground.frame = readyFrame;
        _startWarBackground.center = _readyButton.center;
        [self insertSubview:_startWarBackground belowSubview:_readyButton];
        _startWarBackground.center = CGPointMake(width/2, height-200);
        _readyButton.center = CGPointMake(_startWarBackground.center.x-20,_startWarBackground.center.y);
        
        /// LEAVE BUTTON ///
        CGRect leaveButtonFrame = CGRectMake(50,(height/2) + 200,150,50);
        _leaveRoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_leaveRoomButton setFrame:leaveButtonFrame];
        [_leaveRoomButton.titleLabel setFont:[UIFont fontWithName:BIG_FONT size:15]];
        [_leaveRoomButton setTitle:@"<< More Wars" forState:UIControlStateNormal];
        [_leaveRoomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        /// LEAVE BACKGROUND ///
        _leaveRoomBackground = [UIImageView new];
        _leaveRoomBackground.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *leaveURL = [[NSBundle mainBundle] URLForResource:@"leaveboard" withExtension:@"gif"];
        _leaveRoomBackground.image = [UIImage animatedImageWithAnimatedGIFURL:leaveURL];
        CGRect leaveFrame = _leaveRoomButton.frame;
        leaveFrame.size.width += 60;
        _leaveRoomBackground.frame = leaveFrame;
        _leaveRoomBackground.center = CGPointMake(width/2,height-100);
        [self insertSubview:_leaveRoomBackground belowSubview:_leaveRoomButton];
        _leaveRoomButton.center = CGPointMake(_leaveRoomBackground.center.x-20,_leaveRoomBackground.center.y);
        
        /***********************
         * TARGET-ACTION PAIRS *
         ***********************/
        
        /// READY BUTTON ///
        [self.readyButton addTarget:self
                             action:@selector(readyClicked)
                   forControlEvents:UIControlEventTouchUpInside];
        
        /// LEAVE BUTTON ///
        [self.leaveRoomButton addTarget:self
                             action:@selector(leaveRoom:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        
        /// Put it all together ///
        [self addSubview:_roomNameLabel];
        [self addSubview:_readyButton];
        [self addSubview:_leaveRoomButton];
    }
    return self;
}

#pragma mark -
#pragma Table View
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [self addSubview:self.tableView];
}

- (UITableView *)getTableView {
    return self.tableView;
}


#pragma mark -
#pragma mark Actions

- (void)readyClicked {
    NSURL *explodeURL = [[NSBundle mainBundle] URLForResource:@"buttonexplode" withExtension:@"gif"];
    self.startWarBackground.image = [UIImage animatedImageWithAnimatedGIFURL:explodeURL];
    
    self.readyButton.transform = CGAffineTransformMakeRotation(-M_PI*0.04);
    
    [_readyButton setUserInteractionEnabled:NO];
    [_delegate readyClicked];
}

- (void)leaveRoom:(id)sender {
    [_delegate leaveRoom];
}

- (void)showReady:(BOOL)show {
    self.readyButton.hidden = !show;
    self.startWarBackground.hidden = !show;
}

@end
