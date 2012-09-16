//
//  ConnectViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ConnectViewController.h"
#import "WifiConnection.h"
#import <netinet/in.h>
#import <sys/socket.h>

@interface ConnectViewController () {
    NSFileHandle *socketHandle;
    NSNetService *netSrvc;
    NSMutableArray *connections;
}

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    services = [[NSMutableArray alloc] init];

    netSrvc = [[NSNetService alloc] initWithDomain:@""
                                              type:@"_cardgames._tcp"
                                              name:@"Card Games - iPad" port:1234];
    if (netSrvc) {
        [netSrvc setDelegate:self];
        [netSrvc publish];
    } else {
        NSLog(@"An error occurred initializing the NSNetService object.");
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// Sent when the service is about to publish
- (void)netServiceWillPublish:(NSNetService *)netService
{
    NSLog(@"netServiceWillPublish");
    [services addObject:netService];
    // You may want to do something here, such as updating a user interface
}

// Sent if publication fails
- (void)netService:(NSNetService *)netService
     didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"didNotPublish");
    [self handleError:[errorDict objectForKey:NSNetServicesErrorCode] withService:netService];
    [services removeObject:netService];
}

// Sent when the service stops
- (void)netServiceDidStop:(NSNetService *)netService
{
    [services removeObject:netService];
    // You may want to do something here, such as updating a user interface
}

// Error handling code
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service
{
    NSLog(@"An error occurred with service %@.%@.%@, error code = %@",
          [service name], [service type], [service domain], error);
    // Handle error here
}

@end
