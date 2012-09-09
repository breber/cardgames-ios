//
//  HorizontalTableViewCell.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    assert([aDecoder isKindOfClass:[NSCoder class]]);
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    }
    
    assert(self);
    return self;
}

@end
