//
//  LetterView.m
//  WordWar
//
//  Created by Christine Lee on 7/11/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "LetterView.h"
#import "LetterPiece.h"
#import "GameView.h"

@interface LetterView () {
    BOOL _isWord;
}

@property (nonatomic) NSInteger placeholders; //number of placeholder letters
@property (nonatomic) BOOL hasPlaceholders;

@property (nonatomic, weak) id tapTarget;
@property (nonatomic) SEL tapAction;

@property (nonatomic) NSInteger bufferWidth;
@property (nonatomic) NSInteger bufferHeight;
@property (nonatomic) NSInteger cornerRadius;
@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger columns;

@end

@implementation LetterView

#pragma mark - 
#pragma mark Initializer
- (instancetype)initWithLetterCapacity:(NSInteger)capacity
                           bufferWidth:(NSInteger)bufferWidth
                          bufferHeight:(NSInteger)bufferHeight
                                  rows:(NSInteger)rows
                               columns:(NSInteger)columns
                      letterSideLength:(CGFloat)pieceLength
                          cornerRadius:(NSInteger)cornerRadius
                          placeholders:(BOOL)placeholders {
    self = [super init];
    if (self) {
        _capacity = capacity;
        _bufferHeight = bufferHeight;
        _bufferWidth = bufferWidth;
        _cornerRadius = cornerRadius;
        _rows = rows;
        _columns = columns;
        _pieceLength = pieceLength;
        _hasPlaceholders = placeholders;
        
        _letters = [NSMutableArray array];
        _isWord  = NO;
        
        CGFloat width;
        if (bufferWidth >= 0)
            width = _columns*_pieceLength + (_columns+1)*_bufferWidth;
        else
            width = _columns*_pieceLength + (_columns-1)*_bufferWidth + 2*5; //5 buffer on either side
        CGFloat height = _rows*_pieceLength + (_rows+1)*_bufferHeight;
        CGRect frame = CGRectMake(0,0, width, height);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -
#pragma mark Getters
- (NSString *)wordCreated {
    NSString *str = @"";
    for (LetterPiece *piece in self.letters) {
        if (!piece.letter) return str; //TODO: need to fix
        str = [str stringByAppendingString:piece.letter];
    }
    return str;
}

- (BOOL)isFull {
    return self.hasPlaceholders ? self.placeholders == 0 : self.letters.count == self.capacity;
}

- (BOOL)isWord {
    return _isWord;
}

- (LetterPiece *)pieceFromLetter:(NSString *)letter {
    LetterPiece *piece = [[LetterPiece alloc] initWithLetter:letter
                                                cornerRadius:self.cornerRadius
                                                  sideLength:self.pieceLength
                                                   tapTarget:self.tapTarget
                                                   tapAction:self.tapAction];
    if (self.cover) [self.superview insertSubview:piece belowSubview:self.cover];
    else [self.superview addSubview:piece];
    return piece;
}

#pragma mark -
#pragma mark Setters
- (void)setLetterColor:(BOOL)wordPossible {
    if (wordPossible) {
        for (LetterPiece *piece in self.letters)
            piece.image = [LetterPiece wordGIF];
    } else {
        for (LetterPiece *piece in self.letters)
            piece.image = [LetterPiece gibberishImage];
    }
}

- (void)setTapGestureTarget:(id)target
                     action:(SEL)action {
    _tapTarget = target;
    _tapAction = action;
}

#pragma mark -
#pragma mark Updates to Contents
//returns the piece that it replaces
- (LetterPiece *)addLetter:(LetterPiece *)piece
                   atIndex:(NSInteger)index
                  fromView:(LetterView *)fromView {
    [fromView removeLetterPiece:piece];
    
    piece.container = self;
    
    //generate placeholder if the previous view has placeholders
    if (fromView && fromView.hasPlaceholders) {
        LetterPiece *placeholder = [fromView addPlaceholderAtIndex:piece.index];
        [self.superview addSubview:placeholder];
        [self.superview sendSubviewToBack:placeholder];
        
    }
    
    LetterPiece *replacedPiece = nil; //to be returned for the view to do with as it pleases
    //only replacing a letter if there are letters in the view
    //TODO:
    if (self.letters.count > 0 && index < self.letters.count) {
        //remove the old letter, and keep it only if it isn't a placeholder
        replacedPiece = [self.letters objectAtIndex:index];
        [replacedPiece removeFromSuperview];
        [self removeLetterPiece:replacedPiece];
        if (replacedPiece && replacedPiece.isPlaceholder) replacedPiece = nil; //throw away placeholder
    }
    
    //insert the letter
    if (index <= self.letters.count)
        [self.letters insertObject:piece atIndex:index];
    
    if (self != fromView) {
        //correct size and shape
        piece.layer.cornerRadius = self.cornerRadius;
        piece.length = self.pieceLength;
        UITapGestureRecognizer *tapRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self.tapTarget
                                                    action:self.tapAction];
        piece.userInteractionEnabled = YES;
        piece.gestureRecognizers = @[tapRecognizer];
        if (self.cover) [self.superview insertSubview:piece belowSubview:self.cover];
    }
    
    piece.index = index;
    if (self.hasPlaceholders) piece.center = [self centerForLetterAtIndex:index];

    return replacedPiece;
}

- (LetterPiece *)addPlaceholderAtIndex:(NSInteger)index {
    LetterPiece *piece = [[LetterPiece alloc] initWithLetter:nil
                                                cornerRadius:self.cornerRadius
                                                  sideLength:self.pieceLength
                                                   tapTarget:nil
                                                   tapAction:nil];
    piece.index = index;
    piece.center = [self centerForLetterAtIndex:index];
    if (index <= self.letters.count)
        [self.letters insertObject:piece atIndex:index];
    return piece;
}

- (void)removeLetterPiece:(LetterPiece *)piece {
    [self.letters removeObject:piece];
    piece.container = nil;
    
    [self setIsWord];
}

- (void)setIsWord {
    if (!self.hasPlaceholders) {
        NSString *word = self.wordCreated;
        GameView *superview = (GameView *)self.superview;
        
        //check if is a word
        _isWord = word != nil && [superview checkWord:word];
        
        [self setLetterColor:_isWord];
    }
}

- (void)centerView {
    
    for (NSInteger i = 0; i < self.letters.count; i++) {
        LetterPiece *piece = [self.letters objectAtIndex:i];
        CGPoint toPoint = [self centerForLetterAtIndex:i];
        CGPoint velocity = CGPointMake(0,0);
        
        piece.index = i;
        [piece performTranslationAnimationTo:toPoint
                                    velocity:velocity
                                  completion:nil];
    }
}

#pragma mark -
#pragma mark Helper Functions
- (CGPoint)centerForLetterAtIndex:(NSInteger)index {

    NSInteger row = index / self.columns;
    NSInteger column = index % self.columns;
    CGFloat x = 0;
    CGFloat y = self.bufferHeight + row*(self.bufferHeight + self.pieceLength) + self.pieceLength/2;
    
    if (self.hasPlaceholders) {
        //have to display placeholders, center only the last line
        
        NSInteger lettersInLastRow = self.capacity % self.columns;
        if (row == self.rows-1 && lettersInLastRow != 0) {
            //last row, and less than full number of letters in last row
            CGFloat centerX = self.bounds.size.width/2;
            CGFloat distanceFromCenter = column - lettersInLastRow / 2.0;
            
            if (lettersInLastRow%2 == 0) {
                //even number of letters in last row
                
                if (distanceFromCenter >= 0) distanceFromCenter++; //don't want to be 0
                NSInteger direction = distanceFromCenter < 0 ? -1 : distanceFromCenter > 0 ? 1 : 0;
                x += centerX + direction*(self.bufferWidth/2 + self.pieceLength/2); //move one piece away
                distanceFromCenter = (fabs(distanceFromCenter)-1)*direction; //move closer to 0
                x += distanceFromCenter*(self.bufferWidth + self.pieceLength); //move over to correct square
            } else {
                //odd number of letters in last row
                if (self.bufferWidth < 0)
                    x += abs((int)self.bufferWidth)*2; //to account for when buffer is negative, and shifts view to the left
                
                x += centerX + distanceFromCenter*(self.pieceLength+self.bufferWidth);
            }
            
        } else {
            //typical indices, easy calculation
            x = self.bufferWidth + column*(self.bufferWidth + self.pieceLength) + self.pieceLength/2;
        }
    } else {
        //no placeholders, center everything
        CGFloat centerX = self.bounds.size.width/2;
        NSInteger lettersInRow = self.letters.count;
        NSInteger indexFromCenter = index - lettersInRow/2;
        
        if (lettersInRow%2 == 0) {
            //even number of letters in row
            
            if (indexFromCenter >= 0) indexFromCenter++; //don't want to be 0
            NSInteger direction = indexFromCenter < 0 ? -1 : indexFromCenter > 0 ? 1 : 0;
            x += centerX + direction*(self.bufferWidth/2 + self.pieceLength/2); //move one piece away
            indexFromCenter = (abs((int)indexFromCenter)-1)*direction; //move closer to 0
            x += indexFromCenter*(self.bufferWidth + self.pieceLength); //move over to correct square
        } else {
            //odd number of letters in last row
            if (self.bufferWidth < 0) x += self.bufferWidth;
            x += centerX + indexFromCenter*(self.pieceLength+self.bufferWidth);
        }
    }

    CGPoint point = CGPointMake(x + self.frame.origin.x,y + self.frame.origin.y);
    return point;
}

- (NSInteger)firstIndexOfPlaceholder {
    for (NSInteger i = 0; i < self.letters.count; i++) {
        if (((LetterPiece *)[self.letters objectAtIndex:i]).isPlaceholder) return i;
    }
    return -1; //no placeholders
}

@end
