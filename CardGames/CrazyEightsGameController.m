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
    
    if (type == MSG_PLAY_CARD){
        //discard card on game board
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_DRAW_CARD){
        //draw card for player
        [self handleDrawCard];
        [self advanceTurn];
        
    } else if(type == MSG_REFRESH){
        [self refreshPlayers];
        
    } else if(type == MSG_PLAY_EIGHT_C){
        //TODO move to C8 gamecontroller
        self.suitChosen = SUIT_CLUBS;
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_PLAY_EIGHT_D){
        self.suitChosen = SUIT_DIAMONDS;
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_PLAY_EIGHT_H){
        self.suitChosen = SUIT_HEARTS;
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_PLAY_EIGHT_S){
        self.suitChosen = SUIT_SPADES;
        [self handleDiscard:d];
        [self advanceTurn];
        
    }
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
    // TODO update gameboard
    
    // Determine if game is over
    if ([self.game isGameOver:((Player *)[self.game.players objectAtIndex:self.whoseTurn])]){
        [self declareWinner:self.whoseTurn];
        return;
    }
    
    // Figure out whose turn it is next
    if ( self.whoseTurn < [self.game.players count] - 1){
        self.whoseTurn++;
    } else {
        self.whoseTurn = 0;
    }
    
    // Get translated discard pile top
    Card* onDiscard = [self getDiscardPileTranslated];    
    
    // Send next turn to player or computer
    if (((Player *)[self.game.players objectAtIndex:self.whoseTurn]).isComputer){
        [self startComputerTurn];
    } else {
        [self sendCard:onDiscard withTurnCode:MSG_IS_TURN toPlayerIndex:self.whoseTurn];
    }    
}



//This method will handle an 8 being on the discard pile.
- (Card *)getDiscardPileTranslated
{
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
    
    return onDiscard;
}

- (void)startComputerTurn
{
    //TODO make this wait before playing. 
    
    Card* onDiscard = [self getDiscardPileTranslated];
    Player * curPlayer = ((Player*)[self.game.players objectAtIndex:self.whoseTurn]);
    NSMutableArray* cards = curPlayer.cards;
    Card* cardSelected = nil;
        
    // Determine which card to play based on difficulty
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
    } else if(DIF_COMP_HARD == ((Player*)[self.game.players objectAtIndex:self.whoseTurn]).computerDifficulty){
        //TODO Hard, not necessary for 388 turn in.
        for (Card *c in cards) {
            if([CrazyEightsRules canPlay:c withDiscard:onDiscard]){
                cardSelected = c;
            }
        }
    }

    
    
    // Perform action
    if(cardSelected != nil){
        //TODO card discard sound
        [self.game addCard:cardSelected toDiscardPileFromPlayer:curPlayer];
    } else {
        //TODO draw sound
        [self.game drawCardForPlayer:curPlayer];
    }
}

@end
