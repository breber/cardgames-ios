//
//  Player.h
//  CardGames
//
//  Created by Brian Reber on 11/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property(nonatomic, strong) id connection;
@property(nonatomic, strong) NSString *name;

@end