//
//  CrazyEightsTabletGame.h
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Card.h"

@interface CrazyEightsTabletGame : NSObject

@property(nonatomic, strong) NSMutableArray *players;
@property(nonatomic, strong) NSMutableArray *discardPile;

-(void) addPlayer: (Player*)p;
-(int) getNumberOfPlayers;
-(BOOL) isGameOver: (Player*)p;
-(void) discard: (Player*)P : withCard: (Card*) c;
-(Card*) getDiscardPileTop;

@end
