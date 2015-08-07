//
//  LetterPiece.m
//  WordWar
//
//  Created by Christine Lee on 7/11/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "LetterPiece.h"
#import "NonSelectableLabel.h"
#import "LetterView.h"
#import "NSStringScrabbleExtension.h"
#import "GameView.h"
#import "UIImage+animatedGIF.h"

@interface LetterPiece () {
    NSString *_letter; //should be immutable
    NSInteger _points;
}

@property (nonatomic, strong) IBOutlet NonSelectableLabel *letterLabel;
@property (nonatomic, strong) IBOutlet NonSelectableLabel *pointsLabel;
@property (nonatomic, weak) id tapTarget;
@property (nonatomic) SEL tapAction;

@end

@implementation LetterPiece

#pragma mark Initializers
- (instancetype)initWithLetter:(NSString *)letter
                  cornerRadius:(CGFloat)cornerRadius
                    sideLength:(CGFloat)length
                     tapTarget:(id)tapTarget
                     tapAction:(SEL)tapAction {
    self = [super init];
    if (self) {
        _letter = letter;
        _length = length;
        _tapTarget = tapTarget;
        _tapAction = tapAction;
        
        /// VIEW ///
        self.frame = CGRectMake(0,0,_length,_length);
        if (_letter)
            self.image = [LetterPiece defaultLetterImage];
        else
            self.image = [LetterPiece placeholderImage];
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        
        if (_letter) {
            /// LETTER ///
            _letterLabel = [[NonSelectableLabel alloc] init];
            _letterLabel.center = self.center;
            _letterLabel.text = _letter;
            _letterLabel.textAlignment = NSTextAlignmentCenter;
            _letterLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_letterLabel];
            
            /// POINTS ///
            _points = letter.scrabblePoints;
            _pointsLabel = [[NonSelectableLabel alloc] init];
            _pointsLabel.text = [NSString stringWithFormat:@"%ld",_points];
            _pointsLabel.textAlignment = NSTextAlignmentCenter;
            _pointsLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_pointsLabel];
         
            /// TAP ///
            UITapGestureRecognizer *tapRecognizer =
                [[UITapGestureRecognizer alloc] initWithTarget:self.tapTarget
                                                        action:self.tapAction];
            self.userInteractionEnabled = YES;
            [self addGestureRecognizer:tapRecognizer];
            
            [self setLength:length];
        }
    }
    return self;
}

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"<Letter %@ @ %ld> with center: (%f,%f)",
                      self.letter,self.index,self.center.x,self.center.y];
    return desc;
}

#pragma mark -
#pragma mark Getters
- (NSString *)letter {
    return _letter;
}

- (BOOL)isPlaceholder {
    return self.letter == nil;
}

#pragma mark -
#pragma mark Setters
- (void)setLength:(CGFloat)length {
    _length = length;
    self.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                            length, length);
    
    self.letterLabel.font = [UIFont fontWithName:SMALL_FONT size:_length*0.5];
    self.pointsLabel.font = [UIFont fontWithName:SMALL_FONT size:_length*0.3];
    
    [self.letterLabel sizeToFit];
    [self.pointsLabel sizeToFit];
    
    self.letterLabel.center = self.center;
    self.pointsLabel.center = CGPointMake(self.bounds.size.width*0.85, self.bounds.size.height*0.85);
}

#pragma mark - 
#pragma mark Animations
- (void)performTranslationAnimationTo:(CGPoint)toPoint
                               velocity:(CGPoint)velocity
                             completion:(void (^)(POPAnimation *,BOOL))completion {
    CALayer *layer = self.layer;
    
    //create a new animation only if there is no existing animation
    if (!self.translation) {
        self.translation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        [layer pop_addAnimation:self.translation forKey:@"translation"];
    }

    self.translation.fromValue = [NSValue valueWithCGPoint:self.center];
    self.translation.toValue = [NSValue valueWithCGPoint:toPoint];
    self.translation.velocity = [NSValue valueWithCGPoint:velocity];
    __weak LetterPiece *weakSelf = self;
    self.translation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completion) completion(anim,finished);
        [layer pop_removeAnimationForKey:@"translation"];
        weakSelf.translation = nil; //kill it
    };
}

- (void)removePOPAnimationForKey:(NSString *)key {
    [self.layer pop_removeAnimationForKey:key];
}

#pragma mark -
#pragma mark Colors
+ (UIImage *)defaultLetterImage {
    //ready to be placed into the word
    return [UIImage imageNamed:@"purpletile"];
}

+ (UIImage *)placeholderImage {
    //tense blue grey
    return [UIImage imageNamed:@"placeholdertile"];
}

+ (UIImage *)wordGIF {
    //slightly dark green
    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:@"completedwordtile" withExtension:@"gif"];
    return [UIImage animatedImageWithAnimatedGIFURL:gifURL];
}

+ (UIImage *)gibberishImage {
    //light gray
    return [UIImage imageNamed:@"tantile"];
}

@end
