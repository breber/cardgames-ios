//
//  PlayerConnectViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ViewController.h"

@interface PlayerConnectViewController : ViewController <UITableViewDataSource, UITableViewDelegate, NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property(nonatomic, weak) IBOutlet UITableView *servers;

@end
