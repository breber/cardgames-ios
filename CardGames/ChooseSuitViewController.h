//
//  ChooseSuitViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/10/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ViewController.h"

@protocol ChooseSuitDelegate <NSObject>

- (void)handleChooseSuit:(int)suit;

@end

@interface ChooseSuitViewController : ViewController

@property(nonatomic, weak) id <ChooseSuitDelegate> delegate;

- (IBAction)heartsSelected:(id)sender;
- (IBAction)spadesSelected:(id)sender;
- (IBAction)diamondsSelected:(id)sender;
- (IBAction)clubsSelected:(id)sender;

@end
