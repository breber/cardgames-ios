//
//  Player.h
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "WifiConnection.h"


@interface Player : NSObject

@property(nonatomic, strong) WifiConnection *connection;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSMutableArray *cards;

- (NSString *)jsonString:(BOOL) isTurn;

@end
