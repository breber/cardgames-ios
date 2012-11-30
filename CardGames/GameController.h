//
//  GameController.h
//  CardGames
//
//  Created by Peters, Joshua on 11/16/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"
#import "CrazyEightsTabletGame.h"

@protocol GameControllerDelegate <NSObject>

- (void)refreshGameBoard;
- (void)declareWinner:(NSString *)winner;

@end


@interface GameController : NSObject

@property (nonatomic, strong) CrazyEightsTabletGame *game;
@property (nonatomic) int whoseTurn;
@property (nonatomic) int suitChosen;
@property (nonatomic, weak) id <GameControllerDelegate> delegate;

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
