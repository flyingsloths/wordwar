//
//  NonSelectableTextView.m
//  WordWar
//
//  Created by Flying Sloths on 7/12/15.
//  Copyright (c) 2015 Flying Sloths. All rights reserved.
//

#import "NonSelectableLabel.h"

@implementation NonSelectableLabel

- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
