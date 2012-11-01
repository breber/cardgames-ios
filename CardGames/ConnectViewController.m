//
//  ConnectViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Constants.h"
#import "ConnectViewController.h"
#import "Server.h"
#import "WifiConnection.h"
#import "SBJson.h"

@interface ConnectViewController()
{
    Server *server;
    NSMutableArray *connections;
    NSArray *devicesUi;
    NSArray *devicesNames;
}

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    services = [[NSMutableArray alloc] init];
    devicesUi = [[NSArray alloc] initWithObjects:player1Device, player2Device, player3Device, player4Device, nil];
    devicesNames = [[NSArray alloc] initWithObjects:player1Name, player2Name, player3Name, player4Name, nil];

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
- (void)serverFailed:(Server *)server
              reason:(NSString *)reason
{
    NSLog(@"server failed");
}

// Server has accepted a new connection and it needs to be processed
- (void)handleNewConnection:(WifiConnection *)connection
{
    if ([connection isActive]) {
        [services addObject:connection];
        connection.listener = self;
    }
    
    [self updateUI];
}

- (void)updateUI
{
    // TODO: do something
    int i = 0;
    for (WifiConnection *c in services) {
        if ([c isActive]) {
            [[devicesUi objectAtIndex:i] setBackgroundColor:[UIColor lightGrayColor]];
            i++;
        } else {
            [services removeObject:c];
        }
    }
    
    for (; i < 4; i++) {
        [[devicesUi objectAtIndex:i] setBackgroundColor:[UIColor darkGrayColor]];
    }
}


- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int) type
{
    // TODO: implement
    NSLog(@"%@", data);
    int remotePort = connection.data;
    if (MSG_PLAYER_NAME == type) {
        int i = 0;
        for (WifiConnection *c in services) {
            if (c.data == remotePort) {
                SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
                NSDictionary *jsonObject = [jsonParser objectWithString:data];
                UILabel *label = [devicesNames objectAtIndex:i];
                [label setText:[jsonObject objectForKey:@"playername"]];
                [label setHidden:NO];
                break;
            }
            
            i++;
        }
    }
}

@end
