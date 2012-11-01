//
//  HorizontalTableViewCell.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    assert([aDecoder isKindOfClass:[NSCoder class]]);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);

        // Set the selected item's background color
        UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor colorWithRed:1 green:201 / 255.0 blue:14 / 255.0 alpha:1];
        self.selectedBackgroundView = bgView;
    }
    
    assert(self);
    return self;
}

@end
