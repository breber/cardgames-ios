//
//  ConnectViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Constants.h"
#import "ConnectViewController.h"
#import "Player.h"
#import "Server.h"
#import "WifiConnection.h"

@interface ConnectViewController()

@property(nonatomic, weak) IBOutlet UIButton *startButton;
@property(nonatomic, strong) IBOutletCollection(UILabel) NSArray *playerNameLabels;
@property(nonatomic, strong) IBOutletCollection(UIView) NSArray *playerDevices;
@property(nonatomic, strong) IBOutletCollection(UIActivityIndicatorView) NSArray *playerLoading;

@property(nonatomic, strong) Server *server;

@property(nonatomic, strong) NSMutableArray *players;

// Keeps track of active services or services about to be published
//@property(nonatomic, strong) NSMutableArray *services;

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
    self.players = [[NSMutableArray alloc] init];
    
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
    // Occasionally, iOS devices connecting connect on one port,
    // then connect immediately on another port. So if we already
    // have a player with a connection to the same IP address,
    // just close the old connection, and update to use the new
    // connection.
    BOOL alreadyFound = NO;
    for (Player *p in self.players) {
        if ([connection.connectionId isEqualToString:[p.connection connectionId]]) {
            WifiConnection *c = p.connection;
            [c closeConnections];
            p.connection = connection;
            connection.delegate = self;
            alreadyFound = YES;
            break;
        }
    }
    
    if ([connection isActive] && !alreadyFound) {
        Player *player = [[Player alloc] init];
        player.connection = connection;
        connection.delegate = self;
        
        [self.players addObject:player];
    }
    
    [self updateUI];
}

- (void)updateUI
{
    // TODO: do something
    int i = 0;
    for (Player *p in self.players) {
        if ([p.connection isActive]) {
            [[self.playerDevices objectAtIndex:i] setBackgroundColor:[UIColor lightGrayColor]];
            
            UIActivityIndicatorView *activityIndicator = [self.playerLoading objectAtIndex:i];
            UILabel *label = [self.playerNameLabels objectAtIndex:i];
            label.text = p.name;
            if (p.name) {
                label.hidden = NO;
                [activityIndicator stopAnimating];
            } else {
                label.hidden = NO;
                [activityIndicator startAnimating];
            }

            i++;
        }
    }
    
    for (; i < 4; i++) {
        [[self.playerDevices objectAtIndex:i] setBackgroundColor:[UIColor darkGrayColor]];

        UIActivityIndicatorView *activityIndicator = [self.playerLoading objectAtIndex:i];
        [activityIndicator stopAnimating];
        
        UILabel *label = [self.playerNameLabels objectAtIndex:i];
        label.text = nil;
        label.hidden = YES;
    }
}


- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int)type
{
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSString *connectionId = connection.connectionId;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
    
    if (MSG_PLAYER_NAME == type) {
        int i = 0;
        for (Player *p in self.players) {
            if ([connectionId isEqualToString:[p.connection connectionId]]) {
                p.name = [jsonObject objectForKey:@"playername"];
                break;
            }
            
            i++;
        }
    }
    
    [self updateUI];
}

- (void)outputStreamClosed:(WifiConnection *)connection
{
    if (DEBUG) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    NSString *connectionId = connection.connectionId;

    for (int i = 0; i < self.players.count; i++) {
        Player *p = [self.players objectAtIndex:i];
        if ([connectionId isEqualToString:[p.connection connectionId]]) {
            [self.players removeObject:p];
            break;
        }
    }

    [self updateUI];
}

@end
