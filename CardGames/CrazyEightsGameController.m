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

- (void)handleDiscard:(NSData *)data
{
    //TODO
        
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    Card *discardCard = [Card cardWithValues:jsonObject];
    
    [self.game addCard:discardCard toDiscardPileFromPlayer:[self.game.players objectAtIndex:self.whoseTurn]];
}

- (void)handleDrawCard
{
    Card * cardDrawn = [self.game drawCardForPlayer:((Player *)[self.game.players objectAtIndex:self.whoseTurn])];
    
    if(cardDrawn != nil){
        // send the card to the player
        [self sendCard:cardDrawn withTurnCode:MSG_CARD_DRAWN toPlayerIndex:self.whoseTurn];
    } else {
        //TODO we have a problem, need to reshuffle deck or something worse.
    }
}


- (void)advanceTurn
{
    //TODO
    
    //determine if game is over
    
    
    // Figure out whose turn it is next
    if ( self.whoseTurn < [self.game.players count] - 1){
        self.whoseTurn++;
    } else {
        self.whoseTurn = 0;
    }
    
    // handle logic for changing suit for 8 played
    Card* onDiscard = [self.game getDiscardPileTop];
    
    if(onDiscard.value == EIGHT_VALUE){
        
        //default to suit of card
        if(self.suitChosen == -1){
            self.suitChosen = onDiscard.suit;
        }
        
        //update discard value
        onDiscard = [Card cardWithValues:onDiscard.value withSuit:self.suitChosen andId:onDiscard.cardId];
    }
    
    
    if (((Player *)[self.game.players objectAtIndex:self.whoseTurn]).isComputer){
        [self startComputerTurn];
    } else {
        [self sendCard:onDiscard withTurnCode:MSG_IS_TURN toPlayerIndex:self.whoseTurn];
    }
    
    
    
    
    
}

- (void)startComputerTurn
{
    Card* onDiscard = [self.game getDiscardPileTop];
    Player * curPlayer = ((Player*)[self.game.players objectAtIndex:self.whoseTurn]);
    NSMutableArray* cards = curPlayer.cards;
    
    Card* cardSelected = nil;
    
    //TODO computer difficulty setting
    if(DIF_COMP_EASY == ((Player*)[self.game.players objectAtIndex:self.whoseTurn]).computerDifficulty){
        //easy
        for (Card *c in cards) {
            if([CrazyEightsRules canPlay:c withDiscard:onDiscard]){
                cardSelected = c;
            }
        }
    } else if(DIF_COMP_MEDIUM == ((Player*)[self.game.players objectAtIndex:self.whoseTurn]).computerDifficulty){
        //TODO medium
        for (Card *c in cards) {
            if([CrazyEightsRules canPlay:c withDiscard:onDiscard]){
                cardSelected = c;
            }
        }
    }

    
    
    
    if(cardSelected != nil){
        //TODO card discard sound
        
        [self.game addCard:cardSelected toDiscardPileFromPlayer:curPlayer];
    } else {
        [self.game drawCardForPlayer:curPlayer];
         
        
    }
    
}

@end
