//
//  Deck.h
//  CardGames
//
//  Created by Jamie Kujawa on 11/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

@property(nonatomic) NSArray *deck;

- (NSArray*) createDeck;

@end
