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

+ (Card *)cardWithValues:(NSDictionary *)values;
+ (Card *)cardWithValues:(int)value withSuit:(int)suit andId:(int)cardId;

- (BOOL)isEqualToCard:(Card *)card;
- (NSString *)jsonString;
- (NSDictionary *)jsonObject;
- (NSString *)cardImagePath;

@end
