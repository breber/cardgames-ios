//
//  GameBoardPauseViewController.m
//  CardGames
//
//  Created by Brian Reber on 12/1/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "GameBoardPauseViewController.h"

@interface GameBoardPauseViewController ()

@end

@implementation GameBoardPauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)resumeButtonPressed
{
    [self.delegate gameShouldResume];
}

- (IBAction)mainMenu:(id)sender
{
    [self.delegate gameShouldEnd];
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
