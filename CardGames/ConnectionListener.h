//
//  ConnectionListener.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

// Forward declare WifiConnection
@class WifiConnection;

@protocol ConnectionListener <NSObject>

@optional
- (void)outputStreamOpened:(WifiConnection *)connection;
- (void)outputStreamClosed:(WifiConnection *)connection;
- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int) type;

@end
