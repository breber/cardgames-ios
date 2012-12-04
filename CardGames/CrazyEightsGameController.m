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

- (id)init
{
    self = [super init];
    
    self.suitChosen = -1;
    
    return self;
}


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

    // Update gameboard
    [self.delegate gameStateDidUpdate:self];

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
    } else if ([DIF_COMP_MEDIUM isEqualToString:compDifficulty] || [DIF_COMP_HARD isEqualToString: compDifficulty]) {
        // TODO: remove check for Hard in this if statement once Hard is implemented
        NSMutableArray * sameSuit = [[NSMutableArray alloc]init];
        NSMutableArray * sameNum = [[NSMutableArray alloc]init];
        NSMutableArray * special = [[NSMutableArray alloc]init];
        
        // array with the 5 suits counts
        NSInteger suits[5];
        for (int i = 0; i<5; i++) {
            suits[i] = 0;
        }
        
        int maxSuitIndex = 0;
        
        for (Card *c in cards) {
            // see if it is a special card
            if(c.value == EIGHT_VALUE || c.suit == SUIT_JOKER){
                [special addObject:c];
            }
            
            suits[c.suit]++;
            if(suits[c.suit] > suits[maxSuitIndex] && c.suit != SUIT_JOKER){
                maxSuitIndex = c.suit;
            }
            
            if(c.suit == onDiscard.suit && [CrazyEightsRules canPlay:c withDiscard:onDiscard]){
                [sameSuit addObject:c];
            } else if(c.value == onDiscard.value && c.suit != SUIT_JOKER && [CrazyEightsRules canPlay:c withDiscard:onDiscard]){
                [sameNum addObject:c];
            }
        }
        
        BOOL moreOfOtherSuit = NO;
        for(Card *c in sameNum){
            if(suits[c.suit] > suits[onDiscard.suit]){
                moreOfOtherSuit = YES;
                break;
            }
        }
        
        if(onDiscard.suit == SUIT_JOKER){
            for (Card *c in cards) {
                if (c.suit == maxSuitIndex && c.value != EIGHT_VALUE) {
                    cardSelected = c;
                    break;
                }
            }
            if(cardSelected == nil){
                for (Card *c in cards) {
                    if (c.suit == maxSuitIndex) {
                        cardSelected = c;
                        break;
                    }
                }
            }
        } else if(moreOfOtherSuit && [sameNum count] > 0){
            cardSelected = [sameNum objectAtIndex:0];
            for (Card * c in sameNum) {
                if(suits[c.suit] > suits[cardSelected.suit]){
                    cardSelected = c;
                }
            }
        } else if([sameSuit count] > 0){
            cardSelected = [sameSuit objectAtIndex:0];
            BOOL hasAnotherCardWithIndex = NO;
            for (Card * c in sameSuit) {
                for (Card * c1 in cards) {
                    if(![c isEqual:c1] && c.value == c1.value && suits[c.suit] <= suits[c1.suit]){
                        cardSelected = c;
                        hasAnotherCardWithIndex = YES;
                        break;
                    }
                }
                if(hasAnotherCardWithIndex){
                    break;
                }
            }
        } else if([special count]){
            cardSelected = [special objectAtIndex:0];
            if(cardSelected != nil && cardSelected.value == EIGHT_VALUE){
                self.suitChosen = maxSuitIndex;
            }
        } // else { no card selected }
        
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
    if (cardSelected && [CrazyEightsRules canPlay:cardSelected withDiscard:onDiscard]) {
        // TODO: card discard sound
        [self.game addCard:cardSelected toDiscardPileFromPlayer:curPlayer];
    } else {
        //TODO draw sound
        [self.game drawCardForPlayer:curPlayer];
    }

    [self advanceTurn];
}

@end
