//
//  SettingsViewController.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/13/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidUnload {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.computerDifficultyPicker titleForSegmentAtIndex:self.computerDifficultyPicker.selectedSegmentIndex]
                 forKey:@"computerDifficulty"];
    
    /*
     To get the data back out for this setting use:
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSData *myEncodedObject = [defaults objectForKey:@"computerDifficulty"];
     
     */
    
    [self setComputerDifficultyPicker:nil];
    [self setNumberOfComputersPicker:nil];
    [super viewDidUnload];
    
}
@end
