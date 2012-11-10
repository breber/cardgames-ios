//
//  ViewController.m
//  CardGames
//
//  Created by Brian Reber on 8/31/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "RoundedTableView.h"
#import "RoundedTextView.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIView* view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]] ||
            [view isMemberOfClass:[RoundedTextView class]] ||
            [view isMemberOfClass:[RoundedTableView class]])
        {
            [view.layer setMasksToBounds:true];
            [view.layer setCornerRadius:4.0f];
            [view.layer setBorderColor:[UIColor blackColor].CGColor];
            [view.layer setBorderWidth:1.0f];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft) &&
           (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

@end
