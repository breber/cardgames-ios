//
//  ChooseSuitViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/10/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ChooseSuitViewController.h"
#import "Constants.h"

@interface ChooseSuitViewController ()

@end

@implementation ChooseSuitViewController

@synthesize delegate;

- (IBAction)heartsSelected:(id)sender {
    [self.delegate handleChooseSuit:SUIT_HEARTS];
}

- (IBAction)spadesSelected:(id)sender {
    [self.delegate handleChooseSuit:SUIT_SPADES];
}

- (IBAction)diamondsSelected:(id)sender {
    [self.delegate handleChooseSuit:SUIT_DIAMONDS];
}

- (IBAction)clubsSelected:(id)sender {
    [self.delegate handleChooseSuit:SUIT_CLUBS];
}

@end
