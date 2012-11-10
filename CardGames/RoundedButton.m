//
//  RoundedButton.m
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "RoundedButton.h"
#import "UIView+Custom.h"

@implementation RoundedButton

- (void)drawRect:(CGRect)rect
{
    [UIView customizeView:self];
}

@end
