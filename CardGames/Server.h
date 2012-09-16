//
//  Server.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerDelegate.h"

@interface Server : NSObject <NSNetServiceDelegate> {
    uint16_t port;
    CFSocketRef listeningSocket;
    id<ServerDelegate> delegate;
    NSNetService* netService;
}

// Delegate receives various notifications about the state of our server
@property(nonatomic,retain) id<ServerDelegate> delegate;

// Initialize and start listening for connections
- (BOOL)start;
- (void)stop;

@end
