//
//  Player.m
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"
#import "Player.h"

@implementation Player

- (NSString *)description
{
    return [NSString stringWithFormat:@"Player: name: %@, cards: %@, isComputer, %d",
            self.name,
            self.cards,
            self.isComputer];
}

- (NSArray *)jsonCards
{
    NSMutableArray *toRet = [[NSMutableArray alloc] init];

    for (Card *c in self.cards) {
        [toRet addObject:[c jsonObject]];
    }

    return toRet;
}

- (NSString *)jsonString:(BOOL)isTurn withDiscard: (Card*)discardCard
{    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.name, @"playername",
                          [self jsonCards], @"currenthand",
                          [discardCard jsonObject], @"discardCard",
                          [NSNumber numberWithBool:isTurn], @"isturn",
                          nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
