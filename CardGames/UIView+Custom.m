//
//  UIView+Custom.m
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "UIView+Custom.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Custom)

+ (void)customizeView:(UIView *)view
{
    [view.layer setMasksToBounds:true];
    [view.layer setCornerRadius:4.0f];
    [view.layer setBorderColor:[UIColor blackColor].CGColor];
    [view.layer setBorderWidth:1.0f];
}

@end
