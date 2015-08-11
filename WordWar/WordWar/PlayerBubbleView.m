//
//  PlayerBubbleView.m
//  WordWar
//
//  Created by Flying Sloths on 7/14/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "PlayerBubbleView.h"
#import "Player.h"
#import "GameView.h"

CGFloat Radius = 40;
CGFloat RatioOfRadius = 0.83;

@interface PlayerBubbleView ()

@property (nonatomic, strong) UILabel *rankView;
@property (nonatomic, strong) UILabel *scoreView;
@property (nonatomic, readonly) BOOL isMyPlayer;
@property (nonatomic, strong) UIImageView *profilePic;
@property (nonatomic, strong) UIImageView *crown;

@end

@implementation PlayerBubbleView

- (instancetype)initWithPlayer:(Player *)player
                    isMyPlayer:(BOOL)isMyPlayer {
    self = [super init];
    if (self) {
        _player = player;
        _isMyPlayer = isMyPlayer;
        
        self.backgroundColor = player.color;
    
        _rankView = [[UILabel alloc] init];
        _rankView.textAlignment = NSTextAlignmentCenter;
        _rankView.layer.masksToBounds = YES;
        _rankView.backgroundColor = player.color;
        [self addSubview:_rankView];
        
        _scoreView = [[UILabel alloc] init];
        _scoreView.textAlignment = NSTextAlignmentCenter;
        _scoreView.layer.masksToBounds = YES;
        _scoreView.backgroundColor = player.color;
        [self addSubview:_scoreView];
        
        CGRect picFrame = CGRectMake(0,0,Radius*RatioOfRadius,Radius*RatioOfRadius);
        _profilePic = [[UIImageView alloc] initWithFrame:picFrame];
        _profilePic.contentMode = UIViewContentModeScaleAspectFill;
        _profilePic.clipsToBounds = YES;
        _profilePic.image = player.profilePic;
        [self addSubview:_profilePic];
        
        _crown = [UIImageView new];
        _crown.image = [UIImage imageNamed:@"crown"];
        _crown.contentMode = UIViewContentModeScaleAspectFill;
        _crown.frame = CGRectMake(0,0,Radius/2,30);
        [self addSubview:_crown];
        if (isMyPlayer)
            _crown.transform = CGAffineTransformMakeRotation(-M_PI*0.15);
        else
            _crown.transform = CGAffineTransformMakeRotation(M_PI*0.15);
        
        self.radius = Radius;
        [self updateRank];
        [self updateScore];
    }
    return self;
}

#pragma mark -
#pragma mark Setters
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    
    //outer background
    self.layer.cornerRadius = radius;
    CGRect bounds = self.bounds;
    bounds.size.width = radius*2;
    bounds.size.height = radius*2;
    self.bounds = bounds;
    
    //inner image
    bounds = self.profilePic.bounds;
    bounds.size.width = (radius*RatioOfRadius)*2;
    bounds.size.height = (radius*RatioOfRadius)*2;
    self.profilePic.bounds = bounds;
    self.profilePic.layer.cornerRadius = bounds.size.width/2;
    self.profilePic.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    bounds = self.rankView.bounds;
    bounds.size.width = (radius*0.6);
    bounds.size.height = (radius*0.6);
    self.rankView.bounds = bounds;
    self.rankView.layer.cornerRadius = _rankView.bounds.size.width/2;
    
    self.rankView.font = [UIFont fontWithName:BIG_FONT size:radius*0.5];
    self.scoreView.font = [UIFont fontWithName:BIG_FONT size:radius*0.4];

    [self.scoreView sizeToFit];
    bounds = self.scoreView.bounds;
    bounds.size.width += 15;
    bounds.size.height = bounds.size.width;
    self.scoreView.bounds = bounds;
    self.scoreView.layer.cornerRadius = self.scoreView.bounds.size.width/2;
    
    if (!self.isMyPlayer) {
        self.rankView.center = CGPointMake(self.bounds.size.width*0.92,self.bounds.size.height*0.92);
        self.scoreView.center = CGPointMake(self.bounds.size.width*0.05,self.bounds.size.height*0.90);
        self.crown.center = CGPointMake(self.bounds.size.width*0.86,self.bounds.size.height*0.05);
    } else {
        self.rankView.center = CGPointMake(self.bounds.size.width,self.bounds.size.height*0.57);
        self.scoreView.center = CGPointMake(self.bounds.size.width*0.95, self.bounds.size.height*0.08);
        self.crown.center = CGPointMake(self.bounds.size.width*0.3,0);
    }
}

- (void)setProfilePicture:(UIImage *)profilePic {
    _profilePic.image = profilePic;
}

#pragma mark -
#pragma mark Updates
- (void)updateRank {
    self.rankView.text = [NSString stringWithFormat:@"%ld",self.player.rank];
    
    //crowned
    if (self.player.rank == 1)
        self.crown.hidden = NO;
    else
        self.crown.hidden = YES;
}

- (void)updateScore {
    self.scoreView.text = [NSString stringWithFormat:@"%ld",self.player.score];
    self.radius = self.radius;
}

#pragma mark - 
#pragma mark Animations
- (void)performContractionAnimation {
    self.radiusAnimation = [POPSpringAnimation animation];
    POPAnimatableProperty *property =
        [POPAnimatableProperty propertyWithName:@"com.facebook.wordwar.playerbubbleview.radius"
                                    initializer:^(POPMutableAnimatableProperty *prop) {
                                        // read value
                                        prop.readBlock = ^(id obj, CGFloat values[]) {
                                            values[0] = ((PlayerBubbleView *)obj).radius;
                                        };
                                        // write value
                                        prop.writeBlock = ^(id obj, const CGFloat values[]) {
                                            ((PlayerBubbleView *)obj).radius = values[0];
                                        };
                                        // dynamics threshold
                                        prop.threshold = 0.01;
                                    }];
    
    self.radiusAnimation.property = property;
    self.radius = Radius;
    self.radiusAnimation.fromValue = @(self.radius);
    self.radiusAnimation.toValue = @(1.35*Radius);
    self.radiusAnimation.springBounciness = 16.0;
    self.radiusAnimation.springSpeed = 20.0;
    
    PlayerBubbleView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,0.13*NSEC_PER_SEC),dispatch_get_main_queue(),^ {
        self.radiusAnimation.toValue = @(Radius);
        self.radiusAnimation.fromValue = @(weakSelf.radius);
        self.radiusAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            weakSelf.radius = Radius;
            [weakSelf pop_removeAllAnimations]; //done with all animations
        };
    });
    
    [self pop_addAnimation:self.radiusAnimation forKey:@"radius"];
}

+ (CGFloat)radius {
    return Radius;
}

@end
