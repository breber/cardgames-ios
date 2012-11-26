//
//  Player.m
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Player.h"

@implementation Player

- (NSString *)description
{
    return [NSString stringWithFormat:@"Player: name: %@, cards: %@, isComputer, %d", self.name, self.cards, self.isComputer];
}

- (NSString *)jsonString:(BOOL) isTurn
{    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.name, @"name",
                          // TODO: fix this
//                          self.cards, @"cards",
                          [NSNumber numberWithBool:isTurn], @"isturn",
                          nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
