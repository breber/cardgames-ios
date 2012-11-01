//
//  Rules.h
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"

@interface Rules : NSObject

+ (BOOL)canPlay:(Card *)card
    withDiscard:(Card *)discard;

@end
