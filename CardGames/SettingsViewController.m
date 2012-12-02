//
//  SettingsViewController.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/13/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Constants.h"
#import "SettingsViewController.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int computerDifficultyIndex = 0;
    
    NSString *computerDifficulty = [defaults objectForKey:PREF_DIFFICULTY];

    if ([computerDifficulty isEqualToString:DIF_COMP_EASY]) {
        computerDifficultyIndex = 0;
    } else if ([computerDifficulty isEqualToString:DIF_COMP_MEDIUM]) {
        //Add in the future...right now there are only two difficulties
    } else if ([computerDifficulty isEqualToString:DIF_COMP_HARD]) {
        computerDifficultyIndex = 1;
    }

    int numberOfComputersIndex = 0;
    
    NSString *numComputers = [defaults objectForKey:PREF_NUM_COMPUTERS];
    
    if ([numComputers isEqualToString:NUM_COMP_ZERO]) {
        numberOfComputersIndex = 0;
    } else if ([numComputers isEqualToString:NUM_COMP_ONE]) {
        numberOfComputersIndex = 1;
    } else if ([numComputers isEqualToString:NUM_COMP_TWO]) {
        numberOfComputersIndex = 2;
    } else if ([numComputers isEqualToString:NUM_COMP_THREE]) {
        numberOfComputersIndex = 3;
    }

    
    [self.computerDifficultyPicker setSelectedSegmentIndex: computerDifficultyIndex];
    [self.numberOfComputersPicker setSelectedSegmentIndex: numberOfComputersIndex];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.computerDifficultyPicker titleForSegmentAtIndex:self.computerDifficultyPicker.selectedSegmentIndex]
                 forKey:PREF_DIFFICULTY];
    
    [defaults setObject:[self.numberOfComputersPicker titleForSegmentAtIndex:self.numberOfComputersPicker.selectedSegmentIndex]
                 forKey:PREF_NUM_COMPUTERS];
    [defaults synchronize];

    /*
     To get the data back out for this setting use:
     
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSData *myEncodedObject = [defaults objectForKey:PREF_DIFFICULTY];
     
     */
    
    [super viewWillDisappear:animated];
    
}
@end
