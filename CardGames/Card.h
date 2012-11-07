//
//  Card.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

@interface Card : NSObject

@property (nonatomic) int cardId;
@property (nonatomic) int suit;
@property (nonatomic) int value;

- (NSString *)jsonString;
- (NSString *)cardImagePath;

@end
