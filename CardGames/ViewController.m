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
    
    for (UIView* button in [self.view subviews]) {
        if ([button isMemberOfClass:[UIButton class]] ||
            [button isMemberOfClass:[RoundedTextView class]] ||
            [button isMemberOfClass:[RoundedTableView class]])
        {
            [button.layer setMasksToBounds:true];
            [button.layer setCornerRadius:4.0f];
            [button.layer setBorderColor:[UIColor blackColor].CGColor];
            [button.layer setBorderWidth:1.0f];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft) &&
           (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

@end
