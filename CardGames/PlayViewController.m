//
//  PlayViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    connection = [WifiConnection sharedInstance];
    connection.listener = self;
    
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter IP Address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *result = [textField text];
    
    if ([[alertView title] isEqualToString:@"Enter IP Address"]) {
        [connection initNetworkCommunication:result];
    } else if ([[alertView title] isEqualToString:@"Enter Name"]) {
        NSString *toWrite = [NSString stringWithFormat:@"{\"DATA\":\"{\\\"playername\\\":\\\"%@\\\"}\",\"MSG_TYPE\":1915416160}", result];
        [connection write:toWrite];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) outputStreamOpened {
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

@end
