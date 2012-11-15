//
//  CrazyEightsTabletGame.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsTabletGame.h"
#import "WifiConnection.h"
#import "Constants.h"

@interface CrazyEightsTabletGame()

@property(nonatomic, strong) NSMutableArray *discardPile;

@end

@implementation CrazyEightsTabletGame

- (void)addPlayer:(Player *)p
{
    [self.players addObject:p];
}

- (BOOL)isGameOver:(Player *)p
{
    return [p.cards count] == 0;
}

- (void)discard:(Player *)p withCard:(Card *)c
{
    [self.discardPile addObject:c];
    [p.cards removeObject:c];
}

- (void) setup{
    
    self.deck = [[Deck alloc] init];
    [self.deck createDeck];
    self.shuffledDeck = [self.deck shuffleArray];
    
    [self dealCards: self.shuffledDeck];
    
}

- (void) dealCards:(NSArray *) deck{
    
    self.e = [deck objectEnumerator];
    
    /*
    // Deal the given number of cards to each player
    for (int i = 0; i < NUMBER_OF_CARDS_PER_HAND; i++) {
        for (Player p : players) {
            // give them a card
            p.addCard(iter.next());
            
            if (Util.isDebugBuild()) {
                Log.d(TAG, "p.addCard: player[" + p.getId() + "] has " + p.getNumCards() + " cards");
            }
            
            //remove the last card returned by iter.next()
            iter.remove();
        }
    }
     */

    int i;
    for(i = 0; i < NUMBER_OF_CARDS_PER_HAND; i++){
        for (Player *p in self.players){
            [p.cards addObject:[self.e nextObject]];
        }
    }
    
    
}

- (Card *)getDiscardPileTop
{
    return [self.discardPile lastObject];
}

- (void)dropPlayer:(NSString *)connectionId
{
    Player *p = nil;
    
    for (Player *player in self.players) {
        if ([player.connection connectionId] == connectionId) {
            p = player;
            break;
        }
    }
    
    
    //TODO add computer player when player is dropped
    
    if (p) {
        [self.players removeObject:p];
    }
    
}

@end
