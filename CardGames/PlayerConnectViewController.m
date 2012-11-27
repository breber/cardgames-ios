//
//  PlayerConnectViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Constants.h"
#import "PlayerConnectViewController.h"
#import "WifiConnection.h"

@interface PlayerConnectViewController() <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property(nonatomic, strong) NSNetServiceBrowser *serviceBrowser;
@property(nonatomic, strong) NSMutableArray *services;
@property(nonatomic) BOOL searching;

@end

@implementation PlayerConnectViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.services = [[NSMutableArray alloc] init];
    self.searching = NO;

    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [self.serviceBrowser setDelegate:self];
    [self.serviceBrowser searchForServicesOfType:BONJOUR_SERVICE inDomain:@""];
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    self.searching = YES;
    [self updateUI];
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    self.searching = NO;
    [self updateUI];
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict
{
    self.searching = NO;
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode]];
}

// Sent when a service appears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    [self.services addObject:aNetService];
    if (!moreComing) {
        [self updateUI];
    }
}

// Sent when a service disappears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    [self.services removeObject:aNetService];
    
    if (!moreComing) {
        [self updateUI];
    }
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)netService
{
    NSArray *addresses = [netService addresses];
    
    if ([addresses count] > 0) {
        WifiConnection *connection = [WifiConnection sharedInstance];
        if ([connection initNetworkCommunication:netService]) {
            [self performSegueWithIdentifier:@"playerhand" sender:self];
        }
    }
}

- (void)netService:(NSNetService *)netService
     didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"didNotResolve");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNetService * selected = [self.services objectAtIndex:indexPath.row];
    [selected setDelegate:self];
    [selected resolveWithTimeout:5.0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.services count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNetService *c = [self.services objectAtIndex:indexPath.row];
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"services"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"services"];
    }
    
    [[cell textLabel] setText:[c name]];
    return cell;
}

#pragma mark - PlayerConnectViewController private

// Error handling code
- (void)handleError:(NSNumber *)error
{
    NSLog(@"%s - An error occurred. Error code = %d", __PRETTY_FUNCTION__, [error intValue]);
    // Handle error here
}

// UI update code
- (void)updateUI
{
    [self.servers reloadData];
}

@end
