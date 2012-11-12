//
//  CrazyEightsTabletGame.h
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Player.h"
#import "Card.h"

@interface CrazyEightsTabletGame : NSObject

@property(nonatomic, strong) NSMutableArray *players;

- (void)addPlayer:(Player *)p;
- (BOOL)isGameOver:(Player *)p;
- (void)discard:(Player *)p withCard:(Card *)c;
- (Card *)getDiscardPileTop;
- (void)dropPlayer:(NSString *)connectionId;

@end
