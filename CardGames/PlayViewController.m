//
//  PlayViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayViewController.h"
#import "Card.h"
#import "Constants.h"
#import "CrazyEightsPlayerController.h"
#import "SBJson.h"

@implementation PlayViewController

@synthesize cardHand = _cardHand;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerController = [[CrazyEightsPlayerController alloc] init];
    self.playerController.delegate = self;

    // Add the game specific buttons
    [self.playerController addButtons:buttonLayout];
    
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter IP Address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *result = [textField text];
    WifiConnection *connection = [WifiConnection sharedInstance];

    if ([[alertView title] isEqualToString:@"Enter IP Address"]) {
        [connection initNetworkCommunication:result];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.playerController handleSegue:segue sender:sender];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)playerTurnDidChange:(BOOL)withTurn {
    // Nothing to do...
}

- (void)playerHandDidChange {
    [self.cardHand reloadData];
}

- (void)playerDidWin {
    [self performSegueWithIdentifier:@"winner" sender:self];
}

- (void)playerDidLose {
    [self performSegueWithIdentifier:@"loser" sender:self];
}

- (void)gameDidPause {
    [self performSegueWithIdentifier:@"pause" sender:self];
}

- (void)gameDidResume {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showNewScreen:(NSString *)viewController {
    [self performSegueWithIdentifier:viewController sender:self];
}

- (void)dismissScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSIndexPath *)getSelectedCardIndex {
    return [self.cardHand indexPathForSelectedRow];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playerController.hand count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *c = [self.playerController.hand objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    // Set the image of the cell
    UIImage *cardImage = [UIImage imageNamed:[c cardImagePath]];
    
//    if (self.isTurn) {
//        if (![self.playerController.rules canPlay:c withDiscard:self.discardCard]) {
            // TODO: set background color
 
//        }
//    }
    
    [[cell imageView] setImage:cardImage];
    return cell;
}

@end
