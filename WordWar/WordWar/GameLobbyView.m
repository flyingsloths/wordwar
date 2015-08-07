//
//  GameLobbyView.m
//  WordWar
//
//  Created by Christine Lee on 7/8/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "GameLobbyView.h"
#import "GameView.h"
#import "UIImage+animatedGIF.h"

@interface GameLobbyView () {
    __weak id <GameLobbyViewDelegate> _delegate;
}

/// Buttons ///
@property (nonatomic, strong) IBOutlet UIButton *joinGameButton;
@property (nonatomic, strong) IBOutlet UIButton *createGameButton;
@property (nonatomic, strong) UIImageView *createBackground;

/// Text Fields ///
@property (nonatomic, strong) UITextField *nameField;

/// Table View ///
@property (nonatomic, strong) UITableView *tableView;

/// Text View ///
@property (nonatomic, strong) UITextView *titleView;
@property (nonatomic, strong) UIImageView *titleBackground;

/// Spinner ///
@property (nonatomic, strong) UIView *spinnerView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation GameLobbyView

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        
        /**************
         * VIEW SETUP *
         **************/
        CGRect frame = [[UIScreen mainScreen] bounds];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.layer.contents = (id)[UIImage imageNamed:@"stonewall2"].CGImage;
        
        /// CREATE GAME BACKGROUND ///
        _createBackground = [UIImageView new];
        NSURL *bombBoard = [[NSBundle mainBundle] URLForResource:@"startboard" withExtension:@"gif"];
        _createBackground.image = [UIImage animatedImageWithAnimatedGIFURL:bombBoard];
        _createBackground.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_createBackground];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGameButtonPressed:)];
        [_createBackground addGestureRecognizer:tapGesture];
        _createBackground.userInteractionEnabled = YES;
        
        /// CREATE GAME BUTTON ///
        _createGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_createGameButton setTitle:@"Start New War"
                         forState:UIControlStateNormal];
        _createGameButton.titleLabel.font = [UIFont fontWithName:BIG_FONT size:18];
        [_createGameButton addTarget:self
                            action:@selector(createGameButtonPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [_createGameButton sizeToFit];
        CGPoint createCenter = CGPointMake(width/2, height-75);
        [_createGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        CGRect backgroundFrame = _createGameButton.frame;
        backgroundFrame.size.width += 140;
        _createBackground.frame = backgroundFrame;
        _createBackground.center = createCenter;
        _createGameButton.center = CGPointMake(createCenter.x-20,createCenter.y);
        
        /// PLAYER NAME FIELD ///
        CGRect nameFieldFrame = CGRectMake(0, (height/2) + 100, width, 50);
        _nameField = [[UITextField alloc] initWithFrame:nameFieldFrame];
        _nameField.textAlignment = NSTextAlignmentCenter;
        _nameField.placeholder = @"Your name";
        _nameField.hidden = YES;
        
        /// TITLE VIEW ////
        CGRect titleFrame = CGRectMake(0, 30, width, 60);
        _titleView = [[UITextView alloc] initWithFrame:titleFrame];
        _titleView.textAlignment = NSTextAlignmentCenter;
        [_titleView setEditable:NO];
        [_titleView setSelectable:NO];
        [_titleView setUserInteractionEnabled:NO];
        [_titleView setFont:[UIFont fontWithName:BIG_FONT size:30]];
        _titleView.text = @"Choose Your War ";
        _titleView.backgroundColor = [UIColor clearColor];
        
        /// BACKGROUND FOR TITLE ///
        _titleBackground = [UIImageView new];
        backgroundFrame = _titleView.frame;
        _titleBackground.frame = backgroundFrame;
        _titleBackground.center = _titleView.center;
        _titleBackground.image = [UIImage imageNamed:@"signboard"];
        _titleBackground.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_titleBackground];
        
        /// SPINNER VIEW ///
        _spinnerView = [[UIView alloc] initWithFrame:frame];
        _spinnerView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
        _spinnerView.hidden = YES;
    
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.center = CGPointMake(width/2, height/2);
        _spinner.hidesWhenStopped = YES;
        [_spinnerView addSubview:_spinner];
        
        /// Put Everything Together ///
        [self addSubview:_joinGameButton];
        [self addSubview:_createGameButton];
        [self addSubview:_nameField];
        [self addSubview:_titleView];
        [self addSubview:_spinner];
        [self addSubview:_spinnerView];
    }
    return self;
}

#pragma mark -
#pragma mark Spinner
- (void)startSpinner {
    self.spinnerView.hidden = NO;
    [self bringSubviewToFront:self.spinnerView];
    [self.spinner startAnimating];
}

- (void)stopSpinner {
    [self.spinner stopAnimating];
    self.spinnerView.hidden = YES;
}

#pragma mark -
#pragma mark Table View
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    [self addSubview:self.tableView];
}

- (UITableView *)getTableView {
    return self.tableView;
}

#pragma mark -
#pragma mark Actions
- (void)createGameButtonPressed:(id)sender {
    [_delegate createGame];
}

@end
