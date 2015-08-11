//
//  EndGameView.m
//  WordWar
//
//  Created by Flying Sloths on 7/22/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "EndGameView.h"
#import "Player.h"
#import "GameView.h"
#import "PlayerBubbleView.h"

@interface EndGameView () {
    __weak id <EndGameViewDelegate> _delegate;
}

@property (nonatomic, strong) UITextView *messageBox;
@property (nonatomic, strong) NSMutableArray *bubbles;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray *winners;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, weak) Player *myPlayer;

@end

@implementation EndGameView

- (instancetype)initWithMyPlayer:(Player *)myPlayer
                         players:(NSArray *)players
                        delegate:(id<EndGameViewDelegate>)delegate{
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        _players = players.mutableCopy;
        _myPlayer = myPlayer;
        NSMutableArray *allPlayers = _players;
        _bubbles = [NSMutableArray array];
        [allPlayers insertObject:myPlayer atIndex:0];
        self.frame = [UIScreen mainScreen].bounds;
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        NSSortDescriptor *rankSorter = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
        allPlayers = [allPlayers sortedArrayUsingDescriptors:@[rankSorter]].mutableCopy;
        
        for (NSInteger rank = 1; rank <= allPlayers.count; rank++) {
            NSPredicate *predicate =
                [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    Player *player = evaluatedObject;
                    return player.rank == rank;
                }];
            NSArray *currentRankPlayers = [allPlayers filteredArrayUsingPredicate:predicate];
            if (rank == 1) _winners = currentRankPlayers.copy;
            
            int i = 0;
            for (Player *player in currentRankPlayers) {
                //bubbles
                PlayerBubbleView *bubble = [[PlayerBubbleView alloc] initWithPlayer:player
                                                                         isMyPlayer:NO];
                player.bubbleView = bubble;
                
                //the more players, the smaller the bubbles
                if (rank == 1)
                    bubble.radius = _winners.count == 1 ? [EndGameView radiusForRank:1] : [EndGameView radiusForRank:2];
                else
                    bubble.radius = [EndGameView radiusForRank:rank];
                
                PlayerBubbleView *lastBubble = self.bubbles.lastObject;
                if(lastBubble) {
                    CGPoint center = lastBubble.center;
                    center.y += lastBubble.radius;
                    center.y += bubble.radius;
                    center.y += 20;
                    bubble.center = center;
                } else
                    bubble.center = CGPointMake(width/2, bubble.bounds.size.height/2 + 15);
                [self.bubbles addObject:bubble];
                [self addSubview:bubble];
                
                i++;
            }
        }
        
        //button
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button setTitle:@"<< More Wars" forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont fontWithName:BIG_FONT size:18]];
        _button.frame = CGRectMake(0,0,200,20);
        CGPoint center = CGPointMake(width/2,height-_button.frame.size.height/2-50);
        _button.center = center;
        [self addSubview:_button];
        
        [self.button addTarget:self
                        action:@selector(returnToLobbyClicked)
              forControlEvents:UIControlEventTouchUpInside];
        
        if (self.myPlayer.rank == 1)
            self.layer.contents = (id)[UIImage imageNamed:@"gamebg"].CGImage;
        else
            self.layer.contents = (id)[UIImage imageNamed:@"losescreen"].CGImage;

        
        //message box
        _messageBox = [[UITextView alloc] init];
        _messageBox.text = [self messageBoxTextWithWinners:_winners];
        _messageBox.backgroundColor = myPlayer.color;
        _messageBox.textAlignment = NSTextAlignmentCenter;
        _messageBox.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        _messageBox.font = [UIFont fontWithName:BIG_FONT size:15];
        _messageBox.userInteractionEnabled = NO;
        [_messageBox sizeToFit];
        _messageBox.center = CGPointMake(width/2,_button.frame.origin.y-10-_messageBox.frame.size.height);
        _messageBox.layer.cornerRadius = 10;
        [self addSubview:_messageBox];
    }
    return self;
}

- (void)returnToLobbyClicked {
    NSLog(@"Leave to lobby: View");
    [_delegate leaveToLobby];
}

- (NSString *)messageBoxTextWithWinners:(NSArray *)winners {
    if (winners.count == self.players.count) {
        return @"Everyone is a winner! #yay";
    }
    
    NSString *str = @"";
    
    int i = 0;
    for (Player *player in winners) {
        NSString *name = [player.realName componentsSeparatedByString:@" "].firstObject;
        if (i == 0) {
            if (player == self.myPlayer)
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@, you ",name]];
            else
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",name]];
        }
        else {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"and %@ ",name]];
        }
        i++;
    }
    
    str = [str stringByAppendingString:@"won!\n"];
    
    if ([winners indexOfObject:self.myPlayer] != NSNotFound)
        str = [str stringByAppendingString:@"Congratulations! 8)"];
    else
        str = [str stringByAppendingString:@"#getrekt"];
    
    return str;
}

+ (CGFloat)radiusForRank:(NSInteger)rank {
    switch(rank) {
        case 1:
            return 70;
        case 2:
            return 42;
        case 3:
            return 36;
        default:
            return 28;
    }
}

@end
