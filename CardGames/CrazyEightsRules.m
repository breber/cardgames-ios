//
//  CrazyEightsRules.m
//  CardGames
//
//  Created by Brian Reber on 9/10/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsRules.h"
#import "Constants.h"

@implementation CrazyEightsRules

+ (BOOL)canPlay:(Card *)card
    withDiscard:(Card *)discard
{
    if (card == nil || discard == nil) {
        return NO;
    }
    
    if (card.suit == SUIT_JOKER || card.value == CARD_EIGHT) {
        return YES;
    }
    
    if (discard.value == CARD_EIGHT && discard.suit == card.suit) {
        return YES;
    }
    
    if (discard.suit == SUIT_JOKER) {
        return YES;
    }
    
    if (card.suit == discard.suit || card.value == discard.value) {
        return YES;
    }
    
    return NO;
}

@end
