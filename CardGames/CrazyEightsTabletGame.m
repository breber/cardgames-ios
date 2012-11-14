//
//  CrazyEightsTabletGame.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsTabletGame.h"
#import "WifiConnection.h"

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
