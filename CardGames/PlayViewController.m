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

    // Show the keyboard
    [textPopupTextField becomeFirstResponder];
    
    // Add the game specific buttons
    [self.playerController addButtons:buttonLayout];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // TODO: maybe check to see if the string is in the right format
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Save the player's name
    [self.playerController setName:[textField text]];
    
    [loadingPopupTitle setText:@"Waiting for game to begin..."];
    
    [textPopup setHidden:YES];
    [loadingPopup setHidden:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.playerController handleSegue:segue sender:sender];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)gameRequestingName {
    [textPopupTextField becomeFirstResponder];
     
    [loadingPopup setHidden:YES];
    [textPopup setHidden:NO];
}

- (void)gameDidBegin {
    [overlay setHidden:YES];
}

- (void)gameDidEnd {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
