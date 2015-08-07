//
//  LobbyCell.m
//  WordWar
//
//  Created by Zareen Choudhury on 7/29/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "LobbyCell.h"
#import "GameView.h"

@interface LobbyCell ()
@property (nonatomic, strong) UILabel *roomNameLabel;
@end

@implementation LobbyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.center = self.center;
        _roomNameLabel.textAlignment = NSTextAlignmentCenter;
        [_roomNameLabel setFont:[UIFont fontWithName:SMALL_FONT size:18]];
        [self addSubview:_roomNameLabel];
        
        //background image
        self.backgroundColor = [UIColor clearColor];
        int number = arc4random_uniform(3)+1;
        NSString *swordFile = [NSString stringWithFormat:@"sword%d",number];
        self.layer.contents = (id)[UIImage imageNamed:swordFile].CGImage;
    }
    return self;
}

- (void)setRoomName:(NSString *)roomName {
    _roomName = roomName;
    _roomNameLabel.text = _roomName;
    [_roomNameLabel sizeToFit];
    _roomNameLabel.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectedBackgroundView = self.backgroundView.copy;
    self.selectedBackgroundView.alpha = 0.5;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

@end
