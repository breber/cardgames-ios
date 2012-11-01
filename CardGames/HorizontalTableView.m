//
//  HorizontalTableView.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "HorizontalTableView.h"

@implementation HorizontalTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    assert([aDecoder isKindOfClass:[NSCoder class]]);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        CGRect frame = self.frame;
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
        self.frame = frame;
    }
    
    assert(self);
    return self;
}

@end
