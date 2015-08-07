//
//  WaitingRoomView.m
//  WordWar
//
//  Created by Justice Tention-Palmer on 7/14/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "WaitingRoomView.h"
#import "WaitingRoomViewController.h"

@interface WaitingRoomView () {
    __weak id <WaitingRoomViewDelegate> _delegate;
}

/// Buttons ///
@property (nonatomic, strong) IBOutlet UIButton *readyButton;

/// Text Views ///
@property (nonatomic, strong) IBOutlet UITextView *myPlayerName;
@property (nonatomic, strong) NSMutableArray *otherPlayers;

@property (nonatomic, strong) NSMutableArray *players;

/// Text Fields ///
@property (nonatomic, strong) IBOutlet UITextField *nameField;

@end


@implementation WaitingRoomView

// TODO: What on earth am I suppose to add as an arguement
- (instancetype)initWithMyPlayerName:(NSString *)myName
                        otherPlayers:(NSArray *)otherPlayers
                            delegate:(id<WaitingRoomViewDelegate>) delegate {
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        
        /**************
         * VIEW SETUP *
         **************/
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        /// VIEW ///
        [self setBackgroundColor:[UIColor whiteColor]];
        
        /// READY BUTTON ///
        CGRect readyFrame = CGRectMake(20, 250, 90, 40);
        _readyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_readyButton setFrame:readyFrame];
        [_readyButton setTitle:@"Ready"
                      forState:UIControlStateNormal];
        [_readyButton setUserInteractionEnabled:YES];
        [_readyButton.titleLabel setFont:[UIFont fontWithName:@"ArialMT" size:15]];
        [_readyButton setHidden:NO];
        
        /// MY PLAYER NAME VIEW ///
        CGRect aFrame = CGRectMake(width/2, 250, 90, 70);
        _myPlayerName =  [[UITextView alloc] initWithFrame:aFrame];
        [_myPlayerName setTextAlignment:NSTextAlignmentCenter];
        [_myPlayerName setEditable:NO];
        [_myPlayerName setHidden:YES];
        
        /// PLAYER NAME VIEWS ///
        _players = [NSMutableArray array];
        for (int i = 0; i < otherPlayers.count; i++) {
            CGRect playerNameFrame = CGRectMake(100 + i*50,height/2-100,50,30);
            UITextView *playerName =  [[UITextView alloc] initWithFrame:playerNameFrame];
            [playerName setFrame:playerNameFrame];
            [playerName setText:_otherPlayers[i]];
            [playerName setEditable:NO];
            [playerName setHidden:YES]; // TODO: what does this do????
            [_otherPlayers addObject:playerName];
        }
        
        /* Put everything together */
        [self addSubview:_readyButton];
        [self addSubview:_myPlayerName];
        for (UITextView *playerName in _otherPlayers) [self addSubview:playerName];
        
        /***********************
         * TARGET-ACTION PAIRS *
         ***********************/
        /// Ready Action /// TODO: Add selector
        [self.readyButton addTarget:self
                             action:@selector(readyClicked)
                   forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

#pragma mark -
#pragma mark Setters
- (void)updatePlayers:(NSMutableArray *)players {
    _players = players;
    [self updatePlayersText];
}


#pragma mark -
#pragma mark Buttons
- (void)readyClicked {
    [_delegate readyButtonPressed];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
