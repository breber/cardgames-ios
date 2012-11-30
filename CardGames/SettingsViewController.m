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

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [self.computerDifficultyPicker setSelectedSegmentIndex:]
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
