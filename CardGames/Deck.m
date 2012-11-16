//
//  Deck.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Deck.h"
#import "Constants.h"

@implementation Deck

- (NSMutableArray *)createDeck
{
    self.deck = [NSMutableArray arrayWithObjects:
                     //CLUBS
                     [Card cardWithValues:ACE_VALUE withSuit:SUIT_CLUBS andId:0],
                     [Card cardWithValues:TWO_VALUE withSuit:SUIT_CLUBS andId:1],
                     [Card cardWithValues:THREE_VALUE withSuit:SUIT_CLUBS andId:2],
                     [Card cardWithValues:FOUR_VALUE withSuit:SUIT_CLUBS andId:3],
                     [Card cardWithValues:FIVE_VALUE withSuit:SUIT_CLUBS andId:4],
                     [Card cardWithValues:SIX_VALUE withSuit:SUIT_CLUBS andId:5],
                     [Card cardWithValues:SEVEN_VALUE withSuit:SUIT_CLUBS andId:6],
                     [Card cardWithValues:EIGHT_VALUE withSuit:SUIT_CLUBS andId:7],
                     [Card cardWithValues:NINE_VALUE withSuit:SUIT_CLUBS andId:8],
                     [Card cardWithValues:TEN_VALUE withSuit:SUIT_CLUBS andId:9],
                     [Card cardWithValues:JACK_VALUE withSuit:SUIT_CLUBS andId:10],
                     [Card cardWithValues:QUEEN_VALUE withSuit:SUIT_CLUBS andId:11],
                     [Card cardWithValues:KING_VALUE withSuit:SUIT_CLUBS andId:12],
                     
                     //DIAMONDS
                     [Card cardWithValues:ACE_VALUE withSuit:SUIT_DIAMONDS andId:13],
                     [Card cardWithValues:TWO_VALUE withSuit:SUIT_DIAMONDS andId:14],
                     [Card cardWithValues:THREE_VALUE withSuit:SUIT_DIAMONDS andId:15],
                     [Card cardWithValues:FOUR_VALUE withSuit:SUIT_DIAMONDS andId:16],
                     [Card cardWithValues:FIVE_VALUE withSuit:SUIT_DIAMONDS andId:17],
                     [Card cardWithValues:SIX_VALUE withSuit:SUIT_DIAMONDS andId:18],
                     [Card cardWithValues:SEVEN_VALUE withSuit:SUIT_DIAMONDS andId:19],
                     [Card cardWithValues:EIGHT_VALUE withSuit:SUIT_DIAMONDS andId:20],
                     [Card cardWithValues:NINE_VALUE withSuit:SUIT_DIAMONDS andId:21],
                     [Card cardWithValues:TEN_VALUE withSuit:SUIT_DIAMONDS andId:22],
                     [Card cardWithValues:JACK_VALUE withSuit:SUIT_DIAMONDS andId:23],
                     [Card cardWithValues:QUEEN_VALUE withSuit:SUIT_DIAMONDS andId:24],
                     [Card cardWithValues:KING_VALUE withSuit:SUIT_DIAMONDS andId:25],
                     
                     //HEARTS
                     [Card cardWithValues:ACE_VALUE withSuit:SUIT_HEARTS andId:26],
                     [Card cardWithValues:TWO_VALUE withSuit:SUIT_HEARTS andId:27],
                     [Card cardWithValues:THREE_VALUE withSuit:SUIT_HEARTS andId:28],
                     [Card cardWithValues:FOUR_VALUE withSuit:SUIT_HEARTS andId:29],
                     [Card cardWithValues:FIVE_VALUE withSuit:SUIT_HEARTS andId:30],
                     [Card cardWithValues:SIX_VALUE withSuit:SUIT_HEARTS andId:31],
                     [Card cardWithValues:SEVEN_VALUE withSuit:SUIT_HEARTS andId:32],
                     [Card cardWithValues:EIGHT_VALUE withSuit:SUIT_HEARTS andId:33],
                     [Card cardWithValues:NINE_VALUE withSuit:SUIT_HEARTS andId:34],
                     [Card cardWithValues:TEN_VALUE withSuit:SUIT_HEARTS andId:35],
                     [Card cardWithValues:JACK_VALUE withSuit:SUIT_HEARTS andId:36],
                     [Card cardWithValues:QUEEN_VALUE withSuit:SUIT_HEARTS andId:37],
                     [Card cardWithValues:KING_VALUE withSuit:SUIT_HEARTS andId:38],
                     
                     //SPADES
                     [Card cardWithValues:ACE_VALUE withSuit:SUIT_SPADES andId:39],
                     [Card cardWithValues:TWO_VALUE withSuit:SUIT_SPADES andId:40],
                     [Card cardWithValues:THREE_VALUE withSuit:SUIT_SPADES andId:41],
                     [Card cardWithValues:FOUR_VALUE withSuit:SUIT_SPADES andId:42],
                     [Card cardWithValues:FIVE_VALUE withSuit:SUIT_SPADES andId:43],
                     [Card cardWithValues:SIX_VALUE withSuit:SUIT_SPADES andId:44],
                     [Card cardWithValues:SEVEN_VALUE withSuit:SUIT_SPADES andId:45],
                     [Card cardWithValues:EIGHT_VALUE withSuit:SUIT_SPADES andId:46],
                     [Card cardWithValues:NINE_VALUE withSuit:SUIT_SPADES andId:47],
                     [Card cardWithValues:TEN_VALUE withSuit:SUIT_SPADES andId:48],
                     [Card cardWithValues:JACK_VALUE withSuit:SUIT_SPADES andId:49],
                     [Card cardWithValues:QUEEN_VALUE withSuit:SUIT_SPADES andId:50],
                     [Card cardWithValues:KING_VALUE withSuit:SUIT_SPADES andId:52],
                     
                     //JOKERS
                     [Card cardWithValues:BLACK_JOKER_VALUE withSuit:SUIT_JOKER andId:52],
                     [Card cardWithValues:RED_JOKER_VALUE withSuit:SUIT_JOKER andId:53],
                     
                     nil];
    
    return self.deck;
}

+ (NSMutableArray *)shuffleArray: (NSMutableArray*) array
{    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [temp exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return temp;
}

@end
