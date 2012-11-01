//
//  ServerDelegate.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

@class Server, WifiConnection;

@protocol ServerDelegate

// Server has been terminated because of an error
- (void)serverFailed:(Server *)server
              reason:(NSString *)reason;

// Server has accepted a new connection and it needs to be processed
- (void)handleNewConnection:(WifiConnection *)connection;

@end
