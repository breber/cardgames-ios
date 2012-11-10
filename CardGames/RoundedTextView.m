//
//  RoundedTextView.m
//  CardGames
//
//  Created by Brian Reber on 9/21/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "RoundedTextView.h"
#import "UIView+Custom.h"

@implementation RoundedTextView

- (void)drawRect:(CGRect)rect
{
    [UIView customizeView:self];
}

@end
