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

@interface PlayViewController()

@property(nonatomic, weak) IBOutlet UIView *buttonLayout;
@property(nonatomic, weak) IBOutlet UIView *overlay;
@property(nonatomic, weak) IBOutlet UITextField *textPopupTextField;
@property(nonatomic, weak) IBOutlet UIView *textPopup;
@property(nonatomic, weak) IBOutlet UIView *loadingPopup;
@property(nonatomic, weak) IBOutlet UILabel *loadingPopupTitle;
@property(nonatomic, weak) IBOutlet HorizontalTableView *cardHand;

@property(nonatomic, strong) PlayerController *playerController;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.playerController = [[CrazyEightsPlayerController alloc] init];
    self.playerController.delegate = self;

    // Show the keyboard
    [self.textPopupTextField becomeFirstResponder];
    
    // Add the game specific buttons
    [self.playerController addButtons:self.buttonLayout];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO: maybe check to see if the string is in the right format
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Save the player's name
    if ([[textField text] length]) {
        [self.playerController setName:[textField text]];
    } else {
        [self.playerController setName:@"Anonymous"];
    }
    
    [self.loadingPopupTitle setText:@"Waiting for game to begin..."];
    
    [self.textPopup setHidden:YES];
    [self.loadingPopup setHidden:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    [self.playerController handleSegue:segue sender:sender];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)gameRequestingName
{
    [self.textPopupTextField becomeFirstResponder];

    [self.loadingPopup setHidden:YES];
    [self.textPopup setHidden:NO];
}

- (void)gameDidBegin
{
    [self.overlay setHidden:YES];
}

- (void)gameDidEnd
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)playerTurnDidChange:(BOOL)withTurn
{
    // Nothing to do...
}

- (void)playerHandDidChange
{
    [self.cardHand reloadData];
}

- (void)playerDidWin
{
    [self performSegueWithIdentifier:@"winner" sender:self];
}

- (void)playerDidLose
{
    [self performSegueWithIdentifier:@"loser" sender:self];
}

- (void)gameDidPause
{
    [self performSegueWithIdentifier:@"pause" sender:self];
}

- (void)gameDidResume
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showNewScreen:(NSString *)viewController
{
    [self performSegueWithIdentifier:viewController sender:self];
}

- (void)dismissScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSIndexPath *)getSelectedCardIndex
{
    return [self.cardHand indexPathForSelectedRow];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.playerController.hand count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
