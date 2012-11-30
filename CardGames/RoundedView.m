//
//  RoundedView.m
//  CardGames
//
//  Created by Brian Reber on 11/30/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "RoundedView.h"
#import "UIView+Custom.h"

@implementation RoundedView

- (void)drawRect:(CGRect)rect
{
    [UIView customizeView:self];
}

@end
