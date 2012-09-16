//
//  ConnectViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ConnectViewController.h"
#import "Server.h"
#import "WifiConnection.h"

@interface ConnectViewController () {
    Server *server;
    NSMutableArray *connections;
}

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    services = [[NSMutableArray alloc] init];

    server = [[Server alloc] init];
    server.delegate = self;
    [server start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [server stop];
    // Release any retained subviews of the main view.
}

// Server has been terminated because of an error
- (void)serverFailed:(Server*)server reason:(NSString*)reason {
    NSLog(@"server failed");
}

// Server has accepted a new connection and it needs to be processed
- (void)handleNewConnection:(WifiConnection*)connection {
    if ([connection isActive]) {
        [services addObject:connection];
    }
    
    [self updateUI];
}

- (void)updateUI {
    // TODO: do something
}

@end
