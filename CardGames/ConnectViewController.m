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

@interface ConnectViewController()

@property(nonatomic, strong) Server *server;
@property(nonatomic, strong) NSMutableArray *connections;
@property(nonatomic, strong) NSArray *devicesUi;
@property(nonatomic, strong) NSArray *devicesNames;

// Keeps track of active services or services about to be published
@property(nonatomic, strong) NSMutableArray *services;

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.services = [[NSMutableArray alloc] init];
    self.devicesUi = [[NSArray alloc] initWithObjects:player1Device, player2Device, player3Device, player4Device, nil];
    self.devicesNames = [[NSArray alloc] initWithObjects:player1Name, player2Name, player3Name, player4Name, nil];

    self.server = [[Server alloc] init];
    self.server.delegate = self;
    [self.server start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.server stop];
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
        [self.services addObject:connection];
        connection.delegate = self;
    }
    
    [self updateUI];
}

- (void)updateUI
{
    // TODO: do something
    int i = 0;
    for (WifiConnection *c in self.services) {
        if ([c isActive]) {
            [[self.devicesUi objectAtIndex:i] setBackgroundColor:[UIColor lightGrayColor]];
            i++;
        } else {
            [self.services removeObject:c];
        }
    }
    
    for (; i < 4; i++) {
        [[self.devicesUi objectAtIndex:i] setBackgroundColor:[UIColor darkGrayColor]];
    }
}


- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int) type
{
    // TODO: implement
    NSLog(@"%@", data);
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
    int remotePort = connection.data;
    if (MSG_PLAYER_NAME == type) {
        int i = 0;
        for (WifiConnection *c in self.services) {
            if (c.data == remotePort) {
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
                UILabel *label = [self.devicesNames objectAtIndex:i];
                [label setText:[jsonObject objectForKey:@"playername"]];
                [label setHidden:NO];
                break;
            }
            
            i++;
        }
    }
}

@end
