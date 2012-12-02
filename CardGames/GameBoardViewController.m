//
//  GameBoardViewController.m
//  CardGames
//
//  Created by Ashley Nelson on 11/18/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsGameController.h"
#import "GameBoardPauseViewController.h"
#import "GameBoardViewController.h"
#import "GameResultViewController.h"
#import "Constants.h"

@interface GameBoardViewController() <GameBoardPauseDelegate>

@end

@implementation GameBoardViewController

- (void)setupGameController
{
    self.gameController = [[CrazyEightsGameController alloc] init];
    self.gameController.delegate = self;
    [self.gameController setupGameboardWithPlayers:self.players];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Hide the navigation bar for more screen real estate
    self.navigationController.navigationBarHidden = YES;

    // sort IBOutletCollection
	self.playerPositions = [self sortByObjectTag:self.playerPositions];
    
    for (int i = 1; i < 4; i++)
    {
        [self rotateView:i];
    }
    
    [self refreshGameBoard];
}

- (void)refreshGameBoard
{
    for (int i = 0; i < self.gameController.game.players.count; i++) {
        [self redrawCardsForPlayer:i];
    }

    [self changeDiscardImage];
}

- (void)gameStateDidUpdate:(GameController *)controller
{
    [self refreshGameBoard];
}

- (void)gameDidEnd:(GameController *)controller withWinner:(NSString *)winner
{    
    [self performSegueWithIdentifier:@"declarewinner" sender:winner];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"declarewinner"]) {
        ((GameResultViewController *)segue.destinationViewController).title = sender;
    } else if ([segue.identifier isEqualToString:@"gameboardpause"]) {
        GameBoardPauseViewController *vc = (GameBoardPauseViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

- (IBAction)pauseGame
{
    [self performSegueWithIdentifier:@"gameboardpause" sender:self];
    [self.gameController pauseGame];
}

- (IBAction)refreshGame
{
    [self refreshGameBoard];
    [self.gameController refreshPlayers];
}

/*
 * Adds card to player's card array and calls method
 * to draw it to screen.
 */
- (void)addCard:(Card *)card
       toPlayer:(int)playerNumber
{
    Player *tempPlayer = self.gameController.game.players[playerNumber];
    NSMutableArray *tempPlayerHand = tempPlayer.cards;
    [self drawCard:card toPlayer:playerNumber atIndex:tempPlayerHand.count - 1];
}

/*
 * Changes the image on the discard pile.
 */
- (void)changeDiscardImage
{
    NSString *imagePath = [self.gameController.game getDiscardPileTop].cardImagePath;
    UIImage *img = [UIImage imageNamed:imagePath];
    [self.discardPile setImage:img];
    
    [self changeSuitImageToSuit:[self.gameController getSuit]];
}

/*
 * Changes the image in the draw pile.
 */
- (void)changeDrawImage:(NSString *)imagePath
{
    UIImage *img = [UIImage imageNamed:imagePath];
    [self.drawPile setImage:img];
}

/*
 * Draws a player's new card at the end of their hand.
 */
- (void)drawCard:(Card *)card
        toPlayer:(int)playerNumber
         atIndex:(int)cardIndex
{
    UIView *tempView = self.playerPositions[playerNumber];
    
    UIImage *img = [UIImage imageNamed:[card cardImagePath]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((img.size.width * GB_CARD_SCALE * GB_CARD_OVERLAP) *
                                                                         cardIndex, 0, img.size.width * GB_CARD_SCALE,
                                                                         img.size.height * GB_CARD_SCALE)];
    [imgView setImage:img];
    [tempView addSubview:imgView];
}

/*
 * Change the suit image in bottom left corner
 */
- (void)changeSuitImageToSuit:(int)suit
{
    switch (suit) {
        case SUIT_CLUBS:
            [self.suitImage setImage:[UIImage imageNamed:@"clubsuitimage.png"] forState:UIControlStateNormal];
            break;
        case SUIT_DIAMONDS:
            [self.suitImage setImage:[UIImage imageNamed:@"diamondsuitimage.png"] forState:UIControlStateNormal];
            break;
        case SUIT_HEARTS:
            [self.suitImage setImage:[UIImage imageNamed:@"heartsuitimage.png"] forState:UIControlStateNormal];
            break;
        case SUIT_SPADES:
            [self.suitImage setImage:[UIImage imageNamed:@"spadesuitimage.png"] forState:UIControlStateNormal];
            break;
        default:
            [self.suitImage setImage:nil forState:UIControlStateNormal];
            break;
    }
}

/*
 * Redraws all the cards in a player's array.
 */
- (void)redrawCardsForPlayer:(int)playerNumber
{
    UIView *tempView = self.playerPositions[playerNumber];
    
    // Remove all card views
    for (UIImageView *i in tempView.subviews) {
        [i removeFromSuperview];
    }
    
    Player *tempPlayer = self.gameController.game.players[playerNumber];
    NSMutableArray *tempPlayerHand = tempPlayer.cards;
    
    // Replace all card views
    for (int j = 0; j < tempPlayerHand.count; j++)
    {
        [self drawCard:tempPlayerHand[j] toPlayer:playerNumber atIndex:j];
    }
}

/*
 * Rotates the specified view to its correct position.
 */
- (void)rotateView:(int)playerNumber
{
    UIView *currentPlayerView = self.playerPositions[playerNumber];
    
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * playerNumber / 180.0 * M_PI);
    currentPlayerView.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

#pragma mark - GameBoardPauseDelegate

- (void)gameShouldResume
{
    [self.gameController unpauseGame];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gameShouldEnd
{
    // TODO: player pressed main menu on pause screen (we need to send the game over message to all players)
}

@end
