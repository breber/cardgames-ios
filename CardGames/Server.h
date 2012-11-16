//
//  Server.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ServerDelegate.h"

@interface Server : NSObject

// Delegate receives various notifications about the state of our server
@property(nonatomic, weak) id<ServerDelegate> delegate;

// Initialize and start listening for connections
- (BOOL)start;
- (void)stop;

@end
