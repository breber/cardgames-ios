//
//  CenteredView.m
//  CardGames
//
//  Created by Brian Reber on 12/4/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CenteredView.h"

@implementation CenteredView

- (void)layoutSubviews
{
    [super layoutSubviews];

    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    UIView *subview = (self.subviews.count > 0) ? [self.subviews objectAtIndex:0] : nil;
    CGRect frameToCenter = subview.frame;

    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }

    subview.frame = frameToCenter;
}

@end
