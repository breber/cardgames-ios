//
//  GameResultViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/10/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "GameResultViewController.h"

@implementation GameResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)mainMenu:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
