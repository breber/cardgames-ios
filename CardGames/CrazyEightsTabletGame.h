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
@property(nonatomic, strong) NSMutableArray *shuffledDeck;
@property(nonatomic, strong) NSEnumerator *e;

+ (CrazyEightsTabletGame *)sharedInstance;
+ (NSString*)getComputerDifficultyFromPicker;
+ (int) getNumberOfComputerPlayersFromPicker;


- (void)addPlayer:(Player *)p;
- (BOOL)isGameOver:(Player *)p;
- (Card *)getDiscardPileTop;
- (void)dropPlayer:(NSString *)connectionId;
- (void)dealCards;
- (void)setup;
- (Card *)getNextCard;
- (Card *) drawCardForPlayer:(Player *) player;
- (void)addCard:(Card *)card toDiscardPileFromPlayer:(Player *)player;
- (void)addCardsFromDiscardPileToShuffledDeck;

@end
