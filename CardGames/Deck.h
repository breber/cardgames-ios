//
//  Deck.h
//  CardGames
//
//  Created by Jamie Kujawa on 11/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"

@interface Deck : NSObject

@property(nonatomic, strong) NSArray *deck;

- (NSArray *)createDeck;
- (NSMutableArray *)shuffleArray;

@end
