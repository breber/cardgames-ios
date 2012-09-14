//
//  PlayViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalTableView.h"
#import "PlayerController.h"
#import "ViewController.h"

@interface PlayViewController : ViewController <UITableViewDataSource, UITableViewDelegate, PlayerControllerDelegate> {
    IBOutlet UIButton *drawButton;
    IBOutlet UIButton *playButton;
}

@property(nonatomic, strong) IBOutlet HorizontalTableView *cardHand;
@property(nonatomic, strong) IBOutlet PlayerController *playerController;

- (IBAction) drawButtonPressed;
- (IBAction) playButtonPressed;

@end
