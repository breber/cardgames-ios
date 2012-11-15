//
//  CrazyEightsTabletGame.h
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Player.h"
#import "Card.h"
#import "Deck.h"

@interface CrazyEightsTabletGame : NSObject

@property(nonatomic, strong) NSMutableArray *players;
@property(nonatomic, strong) Deck *deck;
@property(nonatomic, strong) NSArray *shuffledDeck;
@property(nonatomic, strong) NSEnumerator *e;

- (void)addPlayer:(Player *)p;
- (BOOL)isGameOver:(Player *)p;
- (void)discard:(Player *)p withCard:(Card *)c;
- (Card *)getDiscardPileTop;
- (void)dropPlayer:(NSString *)connectionId;
- (void) dealCards:(NSArray *) deck;
- (void) setup;

@end
