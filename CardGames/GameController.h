//
//  GameController.h
//  CardGames
//
//  Created by Peters, Joshua on 11/16/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "CrazyEightsTabletGame.h"

@interface GameController : NSObject

@property (nonatomic, strong) CrazyEightsTabletGame * game;
@property (nonatomic) int whoseTurn;

@end
