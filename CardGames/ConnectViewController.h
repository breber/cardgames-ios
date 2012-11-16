//
//  ConnectViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Server.h"
#import "ConnectionDelegate.h"
#import "ViewController.h"

@interface ConnectViewController : ViewController <ServerDelegate, ConnectionDelegate>

@end
