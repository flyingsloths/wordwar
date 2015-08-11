//
//  RoomCell.m
//  WordWar
//
//  Created by Flying Sloths on 7/30/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "RoomCell.h"
#import "GameView.h"

@interface RoomCell ()
@property (nonatomic, strong) UILabel *playerNameLabel;
@end

@implementation RoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _playerNameLabel = [[UILabel alloc] init];
        _playerNameLabel.center = self.center;
        _playerNameLabel.textAlignment = NSTextAlignmentCenter;
        [_playerNameLabel setFont:[UIFont fontWithName:SMALL_FONT size:18]];
        [self addSubview:_playerNameLabel];
        
        //background image
        self.backgroundColor = [UIColor clearColor];
        int number = arc4random_uniform(3)+1;
        NSString *swordFile = [NSString stringWithFormat:@"sword%d",number];
        self.layer.contents = (id)[UIImage imageNamed:swordFile].CGImage;
    }
    return self;
}

- (void)setPlayerName:(NSString *)playerName {
    _playerName = playerName;
    _playerNameLabel.text = _playerName;
    [_playerNameLabel sizeToFit];
    _playerNameLabel.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
    _playerNameLabel.font = [UIFont fontWithName:SMALL_FONT size:18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectedBackgroundView = self.backgroundView.copy;
    self.selectedBackgroundView.alpha = 0.5;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}


@end
