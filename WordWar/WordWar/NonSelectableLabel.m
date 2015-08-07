//
//  NonSelectableTextView.m
//  WordWar
//
//  Created by Christine Lee on 7/12/15.
//  Copyright (c) 2015 Christine Lee. All rights reserved.
//

#import "NonSelectableLabel.h"

@implementation NonSelectableLabel

- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
