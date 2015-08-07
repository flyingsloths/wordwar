//
//  LetterView.h
//  WordWar
//
//  Created by Christine Lee on 7/11/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//
//  Container for the letters. Used for HandView and creating words.

#import <UIKit/UIKit.h>
@class LetterPiece;

@interface LetterView : UIView

@property (nonatomic, strong) NSMutableArray *letters;
@property (nonatomic) NSInteger capacity;
@property (nonatomic) CGFloat pieceLength;
@property (nonatomic, weak) UIView *cover;

- (instancetype)initWithLetterCapacity:(NSInteger)capacity
                           bufferWidth:(NSInteger)bufferWidth
                          bufferHeight:(NSInteger)bufferHeight
                                  rows:(NSInteger)rows
                               columns:(NSInteger)columns
                      letterSideLength:(CGFloat)pieceLength
                          cornerRadius:(NSInteger)cornerRadius
                          placeholders:(BOOL)placeholders NS_DESIGNATED_INITIALIZER;
- (void)removeLetterPiece:(LetterPiece *)letter;
- (LetterPiece *)addLetter:(LetterPiece *)piece
          atIndex:(NSInteger)index
         fromView:(LetterView *)viewFrom;
- (NSString *)wordCreated;
- (BOOL)isFull;
- (NSInteger)firstIndexOfPlaceholder;
- (void)centerView;
- (void)setLetterColor:(BOOL)wordPossible;
- (BOOL)isWord;
- (CGPoint)centerForLetterAtIndex:(NSInteger)index;
- (LetterPiece *)pieceFromLetter:(NSString *)letter;
- (LetterPiece *)addPlaceholderAtIndex:(NSInteger)index;
- (void)setIsWord;
- (void)setTapGestureTarget:(id)target
                     action:(SEL)action;

@end
