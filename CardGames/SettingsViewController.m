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

    // TODO: set the layout based on the NSUserDefaults values...

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int computerDifficultyIndex = 0;
    
    NSString *computerDifficulty = [defaults objectForKey:PREF_DIFFICULTY];

    if ([computerDifficulty isEqualToString:@"Easy"]) {
        computerDifficultyIndex = 0;
    } else if ([computerDifficulty isEqualToString:@"Medium"]) {
        //Add in the future...right now there are only two difficulties
    } else if ([computerDifficulty isEqualToString:@"Hard"]) {
        computerDifficultyIndex = 1;
    }

    int numberOfComputersIndex = 0;
    
    NSString *numComputers = [defaults objectForKey:PREF_NUM_COMPUTERS];
    
    if ([numComputers isEqualToString:@"One"]) {
        numberOfComputersIndex = 0;
    } else if ([numComputers isEqualToString:@"Two"]) {
        numberOfComputersIndex = 1;
    } else if ([numComputers isEqualToString:@"Three"]) {
        numberOfComputersIndex = 2;
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
