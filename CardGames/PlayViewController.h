//
//  PlayViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "WifiConnection.h"

@interface PlayViewController : ViewController <ConnectionListener> {
    WifiConnection *connection;
}

- (void) outputStreamOpened;

@end
