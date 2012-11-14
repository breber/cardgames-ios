//
//  Card.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"

@implementation Card

+ (Card *)cardWithValues:(NSDictionary *)values
{
    Card *c = [[Card alloc] init];
    c.value = [[values objectForKey:@"value"] intValue];
    c.suit = [[values objectForKey:@"suit"] intValue];
    c.cardId = [[values objectForKey:@"id"] intValue];
    
    return c;
}

+ (Card *)cardWithValues:(int) value withSuit:(int) suit andId:(int) cardId
{
    Card *c = [[Card alloc] init];
    c.value = value;
    c.suit = suit;
    c.cardId = cardId;
    
    return c;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Card: id=%d, suit=%d, value=%d", self.cardId, self.suit, self.value];
}

- (NSString *)jsonString
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:self.suit], @"suit",
                         [NSNumber numberWithInt:self.cardId], @"id",
                         [NSNumber numberWithInt:self.value], @"value",
                         nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)cardImagePath
{
    switch (self.cardId) {
        case 0:
            return @"clubs_a.png";
        case 1:
            return @"clubs_2.png";
        case 2:
            return @"clubs_3.png";
        case 3:
            return @"clubs_4.png";
        case 4:
            return @"clubs_5.png";
        case 5:
            return @"clubs_6.png";
        case 6:
            return @"clubs_7.png";
        case 7:
            return @"clubs_8.png";
        case 8:
            return @"clubs_9.png";
        case 9:
            return @"clubs_10.png";
        case 10:
            return @"clubs_j.png";
        case 11:
            return @"clubs_q.png";
        case 12:
            return @"clubs_k.png";
        case 13:
            return @"diamonds_a.png";
        case 14:
            return @"diamonds_2.png";
        case 15:
            return @"diamonds_3.png";
        case 16:
            return @"diamonds_4.png";
        case 17:
            return @"diamonds_5.png";
        case 18:
            return @"diamonds_6.png";
        case 19:
            return @"diamonds_7.png";
        case 20:
            return @"diamonds_8.png";
        case 21:
            return @"diamonds_9.png";
        case 22:
            return @"diamonds_10.png";
        case 23:
            return @"diamonds_j.png";
        case 24:
            return @"diamonds_q.png";
        case 25:
            return @"diamonds_k.png";
        case 26:
            return @"hearts_a.png";
        case 27:
            return @"hearts_2.png";
        case 28:
            return @"hearts_3.png";
        case 29:
            return @"hearts_4.png";
        case 30:
            return @"hearts_5.png";
        case 31:
            return @"hearts_6.png";
        case 32:
            return @"hearts_7.png";
        case 33:
            return @"hearts_8.png";
        case 34:
            return @"hearts_9.png";
        case 35:
            return @"hearts_10.png";
        case 36:
            return @"hearts_j.png";
        case 37:
            return @"hearts_q.png";
        case 38:
            return @"hearts_k.png";
        case 39:
            return @"spades_a.png";
        case 40:
            return @"spades_2.png";
        case 41:
            return @"spades_3.png";
        case 42:
            return @"spades_4.png";
        case 43:
            return @"spades_5.png";
        case 44:
            return @"spades_6.png";
        case 45:
            return @"spades_7.png";
        case 46:
            return @"spades_8.png";
        case 47:
            return @"spades_9.png";
        case 48:
            return @"spades_10.png";
        case 49:
            return @"spades_j.png";
        case 50:
            return @"spades_q.png";
        case 51:
            return @"spades_k.png";
        case 52:
            return @"joker_b.png";
        case 53:
            return @"joker_r.png";
        default:
            return @"";
            break;
    }
}

@end
