//
//  ViewController.m
//  CardGames
//
//  Created by Brian Reber on 8/31/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIView* button in [self.view subviews]) {
        if ([button isMemberOfClass:[UIButton class]]) {
            [button.layer setMasksToBounds:true];
            [button.layer setCornerRadius:4.0f];
            [button.layer setBorderColor:[UIColor blackColor].CGColor];
            [button.layer setBorderWidth:1.0f];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) &&
            (interfaceOrientation != UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

@end
