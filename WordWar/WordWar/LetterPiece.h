//
//  LetterPiece.h
//  WordWar
//
//  Created by Flying Sloths on 7/11/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//
//  Abstraction for one letter in the view
//

#import <pop/POP.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class LetterView;

@interface LetterPiece : UIImageView

@property (nonatomic) NSInteger index;
@property (nonatomic) CGFloat length;
@property (nonatomic, weak) LetterView *container;
@property (nonatomic, strong) POPSpringAnimation *translation;

- (instancetype)initWithLetter:(NSString *)letter
                  cornerRadius:(CGFloat)cornerRadius
                    sideLength:(CGFloat)length
                     tapTarget:(id)tapTarget
                     tapAction:(SEL)tapAction NS_DESIGNATED_INITIALIZER;
- (NSString *)letter;
- (BOOL)isPlaceholder;
- (void)performTranslationAnimationTo:(CGPoint)toPoint
                             velocity:(CGPoint)velocity
                           completion:(void (^)(POPAnimation *,BOOL))completion;


+ (UIImage *)defaultLetterImage;
+ (UIImage *)placeholderImage;
+ (UIImage *)wordGIF;
+ (UIImage *)gibberishImage;

@end
