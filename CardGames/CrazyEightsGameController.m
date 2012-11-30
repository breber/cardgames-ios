//
//  CrazyEightsGameController.m
//  CardGames
//
//  Created by Peters, Joshua on 11/16/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsGameController.h"
#import "CrazyEightsRules.h"
#import "Card.h"
#import "Constants.h"
#import "C8Constants.h"
#import "CrazyEightsTabletGame.h"

@implementation CrazyEightsGameController

- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int)type
{
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    if (type == MSG_PLAY_CARD) {
        // discard card on game board
        [self handleDiscard:d];
        [self advanceTurn];
    } else if (type == MSG_DRAW_CARD) {
        // draw card for player
        [self handleDrawCard];
        [self advanceTurn];
    } else if (type == MSG_REFRESH) {
        [self refreshPlayers];
    } else if (type == MSG_PLAY_EIGHT_C) {
        // TODO move to C8 gamecontroller
        self.suitChosen = SUIT_CLUBS;
        [self handleDiscard:d];
        [self advanceTurn];
    } else if (type == MSG_PLAY_EIGHT_D) {
        self.suitChosen = SUIT_DIAMONDS;
        [self handleDiscard:d];
        [self advanceTurn];
    } else if (type == MSG_PLAY_EIGHT_H) {
        self.suitChosen = SUIT_HEARTS;
        [self handleDiscard:d];
        [self advanceTurn];
    } else if (type == MSG_PLAY_EIGHT_S) {
        self.suitChosen = SUIT_SPADES;
        [self handleDiscard:d];
        [self advanceTurn];
    }
}

- (void)startFirstTurn
{
    Player *p = [self.game.players objectAtIndex:self.whoseTurn];
    Card *onDiscard = [self.game getDiscardPileTop];

    // send first turn
    [self sendCard:onDiscard withTurnCode:MSG_IS_TURN toPlayer:p];
}


- (void)handleDiscard:(NSData *)data
{
    //TODO
        
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    Card *discardCard = [Card cardWithValues:jsonObject];
    
    [self.game addCard:discardCard toDiscardPileFromPlayer:[self.game.players objectAtIndex:self.whoseTurn]];
}

- (void)handleDrawCard
{
    Player *p = [self.game.players objectAtIndex:self.whoseTurn];
    Card *cardDrawn = [self.game drawCardForPlayer:p];
    
    if (cardDrawn) {
        // send the card to the player
        [self sendCard:cardDrawn withTurnCode:MSG_CARD_DRAWN toPlayer:p];
    } else {
        // TODO: we have a problem, need to reshuffle deck or something worse.
    }
}


- (void)advanceTurn
{
    // Update gameboard
    [self.delegate refreshGameBoard];

    Player *p = [self.game.players objectAtIndex:self.whoseTurn];
    
    // Determine if game is over
    if ([self.game isGameOver:p]) {
        [self declareWinner:self.whoseTurn];
        return;
    }
    
    // Figure out whose turn it is next
    if (self.whoseTurn < [self.game.players count] - 1) {
        self.whoseTurn++;
    } else {
        self.whoseTurn = 0;
    }

    p = [self.game.players objectAtIndex:self.whoseTurn];
    
    // Get translated discard pile top
    Card *onDiscard = [self getDiscardPileTranslated];
    
    // Send next turn to player or computer
    if (p.isComputer) {
        [self startComputerTurn];
    } else {
        [self sendCard:onDiscard withTurnCode:MSG_IS_TURN toPlayer:p];
    }    
}


//This method will handle an 8 being on the discard pile.
- (Card *)getDiscardPileTranslated
{
    // handle logic for changing suit for 8 played
    Card* onDiscard = [self.game getDiscardPileTop];
    
    if (onDiscard.value == EIGHT_VALUE) {
        
        //default to suit of card
        if (self.suitChosen == -1) {
            self.suitChosen = onDiscard.suit;
        }
        
        // update discard value
        onDiscard = [Card cardWithValues:onDiscard.value withSuit:self.suitChosen andId:onDiscard.cardId];
    }
    
    return onDiscard;
}

- (int)getSuit
{
    return [self getDiscardPileTranslated].suit;
}

- (void)startComputerTurn
{
    // Make the computer play after a 1 second delay
    [self performSelector:@selector(playComputerTurn) withObject:self afterDelay:1];
}

- (void)playComputerTurn
{
    Card *onDiscard = [self getDiscardPileTranslated];
    Player *curPlayer = [self.game.players objectAtIndex:self.whoseTurn];
    NSMutableArray *cards = curPlayer.cards;
    Card *cardSelected = nil;
    
    NSString *compDifficulty = curPlayer.computerDifficulty;

    // Determine which card to play based on difficulty
    if ([DIF_COMP_EASY isEqualToString:compDifficulty]) {
        // Easy
        for (Card *c in cards) {
            if ([CrazyEightsRules canPlay:c withDiscard:onDiscard]) {
                cardSelected = c;
                break;
            }
        }
    } else if ([DIF_COMP_MEDIUM isEqualToString:compDifficulty]) {
        // TODO: medium
        for (Card *c in cards) {
            if ([CrazyEightsRules canPlay:c withDiscard:onDiscard]) {
                cardSelected = c;
                break;
            }
        }
    } else if ([DIF_COMP_HARD isEqualToString: compDifficulty]) {
        // TODO: Hard, not necessary for 388 turn in.
        for (Card *c in cards) {
            if ([CrazyEightsRules canPlay:c withDiscard:onDiscard]) {
                cardSelected = c;
                break;
            }
        }
    }

    // Perform action
    if (cardSelected) {
        // TODO: card discard sound
        [self.game addCard:cardSelected toDiscardPileFromPlayer:curPlayer];
    } else {
        //TODO draw sound
        [self.game drawCardForPlayer:curPlayer];
    }

    [self advanceTurn];
}

@end
