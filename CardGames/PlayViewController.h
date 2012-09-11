//
//  PlayViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseSuitViewController.h"
#import "HorizontalTableView.h"
#import "ViewController.h"
#import "WifiConnection.h"

@interface PlayViewController : ViewController <ConnectionListener, ChooseSuit, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet HorizontalTableView *cardHand;
    IBOutlet UIButton *drawButton;
    IBOutlet UIButton *playButton;
    WifiConnection *connection;
}

@property(nonatomic, strong) NSMutableArray *hand;

- (IBAction) playButtonPressed;
- (IBAction) drawButtonPressed;

- (void)handleChooseSuit:(int)suit;
- (void) outputStreamOpened;
- (void) newDataArrived:(NSString *)data withType:(int) type;

@end
