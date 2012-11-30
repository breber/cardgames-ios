//
//  Player.h
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "WifiConnection.h"
#import "Card.h"


@interface Player : NSObject

@property(nonatomic, strong) WifiConnection *connection;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSMutableArray *cards;
@property(nonatomic) BOOL isComputer;
@property(nonatomic) NSString * computerDifficulty;

- (NSArray *)jsonCards;
- (NSString *)jsonString:(BOOL)isTurn withDiscard: (Card*)discardCard;

@end
