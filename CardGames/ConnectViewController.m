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

@property(nonatomic, weak) IBOutlet UIButton *startButton;
@property(nonatomic, strong) IBOutletCollection(UILabel) NSArray *playerNameLabels;
@property(nonatomic, strong) IBOutletCollection(UIView) NSArray *playerDevices;
@property(nonatomic, strong) IBOutletCollection(UIActivityIndicatorView) NSArray *playerLoading;


@property(nonatomic, strong) Server *server;
@property(nonatomic, strong) NSMutableArray *connections;

// Keeps track of active services or services about to be published
@property(nonatomic, strong) NSMutableArray *services;

@end

@implementation ConnectViewController

- (NSArray *)sortByObjectTag:(NSArray *)arr
{
    return [arr sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB) {
        return (
               ([objA tag] < [objB tag]) ? NSOrderedAscending  :
               ([objA tag] > [objB tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.services = [[NSMutableArray alloc] init];
    
    // IBOutletCollections apparently aren't sorted by default...
    self.playerNameLabels = [self sortByObjectTag:self.playerNameLabels];
    self.playerDevices = [self sortByObjectTag:self.playerDevices];
    self.playerLoading = [self sortByObjectTag:self.playerLoading];
    
    self.server = [[Server alloc] init];
    self.server.delegate = self;
    [self.server start];
}

- (void)viewDidUnload
{
    [self setPlayerNameLabels:nil];
    [self setStartButton:nil];
    [self setPlayerNameLabels:nil];
    [self setPlayerDevices:nil];
    [self setPlayerLoading:nil];
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
            [[self.playerDevices objectAtIndex:i] setBackgroundColor:[UIColor lightGrayColor]];
            i++;
        } else {
            // TODO: this won't work - concurrent modification
            [self.services removeObject:c];
        }
    }
    
    for (; i < 4; i++) {
        [[self.playerDevices objectAtIndex:i] setBackgroundColor:[UIColor darkGrayColor]];
    }
}


- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int) type
{
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
    int remotePort = connection.data;
    if (MSG_PLAYER_NAME == type) {
        int i = 0;
        for (WifiConnection *c in self.services) {
            if (c.data == remotePort) {
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
                UILabel *label = [self.playerNameLabels objectAtIndex:i];
                [label setText:[jsonObject objectForKey:@"playername"]];
                [label setHidden:NO];
                break;
            }
            
            i++;
        }
    }
}

@end
