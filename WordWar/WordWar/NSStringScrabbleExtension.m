//
//  NSStringScrabbleExtension.m
//  WordWar
//
//  Created by Christine Lee on 7/15/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "NSStringScrabbleExtension.h"

@implementation NSString (ScrabbleEdition)

+ (NSDictionary *)pointLetterDictionary {
    return @{ @"a":[NSNumber numberWithInt:1],
              @"b":[NSNumber numberWithInt:3],
              @"c":[NSNumber numberWithInt:3],
              @"d":[NSNumber numberWithInt:2],
              @"e":[NSNumber numberWithInt:1],
              @"f":[NSNumber numberWithInt:4],
              @"g":[NSNumber numberWithInt:2],
              @"h":[NSNumber numberWithInt:4],
              @"i":[NSNumber numberWithInt:1],
              @"j":[NSNumber numberWithInt:8],
              @"k":[NSNumber numberWithInt:5],
              @"l":[NSNumber numberWithInt:1],
              @"m":[NSNumber numberWithInt:3],
              @"n":[NSNumber numberWithInt:1],
              @"o":[NSNumber numberWithInt:1],
              @"p":[NSNumber numberWithInt:3],
              @"q":[NSNumber numberWithInt:10],
              @"r":[NSNumber numberWithInt:1],
              @"s":[NSNumber numberWithInt:1],
              @"t":[NSNumber numberWithInt:1],
              @"u":[NSNumber numberWithInt:1],
              @"v":[NSNumber numberWithInt:4],
              @"w":[NSNumber numberWithInt:4],
              @"x":[NSNumber numberWithInt:8],
              @"y":[NSNumber numberWithInt:4],
              @"z":[NSNumber numberWithInt:10] };
}

- (NSInteger)scrabblePoints {
    NSDictionary *letterValues = [NSString pointLetterDictionary];
    NSInteger score = 0;
    for (int i = 0; i < self.length; i++) { // TODO: Decide if we want to add or subtract for score.
        NSString *letter = [self substringWithRange:NSMakeRange(i, 1)];
        NSNumber *valueOfLetter = [letterValues objectForKey:letter]; //TODO: this might not work
        score += [valueOfLetter longLongValue];
    }
    if (self.length > 3) {
        double bonus = ((self.length - 3) * 0.2) + 1;
        score *= bonus;
    }
    return score;
}

@end