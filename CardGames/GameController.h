//
//  GameController.h
//  CardGames
//
//  Created by Peters, Joshua on 11/16/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"
#import "CrazyEightsTabletGame.h"

@class GameController;

@protocol GameControllerDelegate <NSObject>

- (void)gameStateDidUpdate:(GameController *)controller;
- (void)gameDidEnd:(GameController *)controller withWinner:(NSString *)winner;

@end


@interface GameController : NSObject

@property (nonatomic, strong) CrazyEightsTabletGame *game;
@property (nonatomic) int whoseTurn;
@property (nonatomic) BOOL isPaused;
@property (nonatomic, weak) id <GameControllerDelegate> delegate;

- (void)pauseGame;
- (void)unpauseGame;
- (void)setupGameboardWithPlayers:(NSMutableArray *)players;
- (void)handleDiscard:(NSData *)data;
- (void)handleDrawCard;
- (void)advanceTurn;
- (void)startComputerTurn;
- (void)sendCard:(Card *)card withTurnCode:(int)msg toPlayer:(Player *)player;
- (void)declareWinner:(int)winner;
- (void)refreshPlayers;
- (void)startFirstTurn;
- (int)getSuit;

@end
