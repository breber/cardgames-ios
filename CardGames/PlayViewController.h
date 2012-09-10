//
//  PlayViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalTableView.h"
#import "ViewController.h"
#import "WifiConnection.h"

@interface PlayViewController : ViewController <ConnectionListener, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet HorizontalTableView *cardHand;
    WifiConnection *connection;
}

@property(nonatomic, strong) NSMutableArray *hand;

- (IBAction) playButtonPressed;
- (IBAction) drawButtonPressed;

- (void) outputStreamOpened;
- (void) newDataArrived:(NSString *)data withType:(int) type;

@end
