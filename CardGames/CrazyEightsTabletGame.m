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

static CrazyEightsTabletGame *instance = nil;

+ (CrazyEightsTabletGame *)sharedInstance
{
    if (instance == nil) {
        instance = [[CrazyEightsTabletGame alloc] init];
    }
    
    return instance;
}

- (void)addPlayer:(Player *)p
{
    [self.players addObject:p];
}

- (BOOL)isGameOver:(Player *)p
{
    return [p.cards count] == 0;
}

- (void)setup
{
    self.players = [[NSMutableArray alloc]init];
    self.deck = [[Deck alloc] init];
    [self.deck createDeck];
    self.shuffledDeck = [Deck shuffleArray:[self.deck deck]];
    
    [self dealCards];
    self.e = [self.shuffledDeck objectEnumerator];
}

- (void)dealCards
{
    for (int i = 0; i < NUMBER_OF_CARDS_PER_HAND; i++) {
        for (Player *p in self.players) {
            [p.cards addObject:[self getNextCard]];
        }
    }
}

- (void)addCard:(Card *)card toDiscardPileFromPlayer:(Player *)player
{
    [self.discardPile addObject: card];
    [player.cards removeObject: card];
}

- (void)addCardsFromDiscardPileToShuffledDeck
{
    Card *c = [self getDiscardPileTop];
    [self.discardPile removeObject:c];
    [self.shuffledDeck addObjectsFromArray:self.discardPile];
    [self.discardPile removeAllObjects];
    [self.discardPile addObject:c];
    [Deck shuffleArray:self.discardPile];
}

- (Card *)getNextCard
{
    Card *c = [self.e nextObject];
    [self.shuffledDeck removeObject:c];
    return c;
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
