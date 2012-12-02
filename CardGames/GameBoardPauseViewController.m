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

- (IBAction)resumeButtonPressed
{

}

- (IBAction)mainMenu:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

@end
