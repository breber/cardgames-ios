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


@protocol GameControllerDelegate <NSObject>

// TODO: make some of these optional
- (void)gameRequestingName;
- (void)gameDidBegin;
- (void)gameDidPause;
- (void)gameDidResume;
- (void)gameDidEnd;


@end


@interface GameController : NSObject

@property (nonatomic, strong) CrazyEightsTabletGame * game;
@property (nonatomic) int whoseTurn;
@property (nonatomic, weak) id <GameControllerDelegate> delegate;

@end
