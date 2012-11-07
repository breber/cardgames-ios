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

@interface PlayViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PlayerControllerDelegate>

@end
