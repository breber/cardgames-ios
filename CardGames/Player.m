//
//  Player.m
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Player.h"

@implementation Player

- (NSString *)jsonString:(BOOL) isTurn
{    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.name, @"name",
                          self.cards, @"cards",
                          isTurn, @"isturn",
                          nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
