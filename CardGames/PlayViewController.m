//
//  PlayViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayViewController.h"
#import "Card.h"
#import "SBJson.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize hand = _hand;

- (void)viewDidLoad {
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
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: result, @"playername", nil];
        [connection write:[dict JSONRepresentation] withType:1915416160];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) outputStreamOpened {
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void) newDataArrived:(NSString *)data withType:(int) type {
    // If this is the init message
    if (type == NSIntegerMax) {
        NSLog(@"App Init...");
    } else if (type == 0) {
        // Setup
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *t in jsonObject) {
            Card *c = [[Card alloc] init];
            c.value = [[t objectForKey:@"value"] intValue];
            c.suit = [[t objectForKey:@"suit"] intValue];
            c.cardId = [[t objectForKey:@"id"] intValue];

           [arr addObject:c];
        }
        
        self.hand = arr;
        [cardHand reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.hand count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *c = [self.hand objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    // Set the image of the cell
    [[cell imageView] setImage:[UIImage imageNamed:[c cardImagePath]]];
    return cell;
}

@end
