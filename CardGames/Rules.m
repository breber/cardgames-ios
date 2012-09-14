//
//  Rules.m
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Rules.h"

@implementation Rules

+ (BOOL)canPlay:(Card *)card withDiscard:(Card *)discard {
    return YES;
}

@end
