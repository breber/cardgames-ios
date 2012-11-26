//
//  GameController.m
//  CardGames
//
//  Created by Peters, Joshua on 11/16/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "GameController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+CardGamesColor.h"
#import "C8Constants.h"
#import "WifiConnection.h"
#import "Player.h"
#import "Card.h"
#import "Constants.h"
#import "CrazyEightsTabletGame.h"
#import "ConnectionDelegate.h"
#import "CrazyEightsRules.h"

@interface GameController() <ConnectionDelegate>

@end

@implementation GameController

- (id) init
{
    self = [super init];
    
    if (self) {
        self.whoseTurn = 0;
        self.game = [CrazyEightsTabletGame sharedInstance];
        
        
    }
    
    return self;
}

- (void) addButtons {
    //TODO
    //add refresh
    
    //add pause
}

- (void) setupGameboardWithPlayers:(NSMutableArray *) players {

    //add players
    self.game.players = players;
    
    int numHumans = [players count];
    
    // Get computer difficulty setting
    NSString *compDifficulty = [[NSUserDefaults standardUserDefaults] stringForKey:@"computerDifficulty"];
    
    // Get number of computers setting
    int numComputers = [CrazyEightsTabletGame getNumberOfComputerPlayersFromPicker];
    
    //TODO make this based on number of computers specified
    for( int i = 0; i < 4 && i < numHumans + numComputers; i++)
    {
        if(i<numHumans)
        {
            ((Player*)[players objectAtIndex:i]).isComputer = NO;
            ((Player*)[players objectAtIndex:i]).computerDifficulty = compDifficulty;
        } else {
            Player *player = [[Player alloc] init];
            player.connection = nil;
            player.name = [NSString stringWithFormat:@"Computer %i", i - numHumans + 1];
            player.isComputer = YES;
            player.computerDifficulty = compDifficulty;
            
            [self.game addPlayer:player];
        }
        
    }
    
    //deal cards
    [self.game setup];
    
    // Let the view controller go 
    [self.delegate gameDidBegin];
    
    //counter to tell which player index
    int i = 0;
    
    //send cards to players
    for (Player* p in self.game.players) {
        //make this class recieve messages from each connection
        p.connection.delegate = self;
        
        //send cards
        [p.connection write:[p jsonString:(self.whoseTurn == i)] withType:MSG_SETUP];
        
        i++;
    }
    NSLog(@"Number of Human Players: %d, Computer Players: %d", numHumans, i - numHumans);
    
    [self startFirstTurn];
}

- (void)startFirstTurn
{
    // Nothing needed in this class
}

- (void)sendCard:(Card*) card withTurnCode:(int) msg toPlayerIndex:(int) index{
    //get the player
    Player* player = [self.game.players objectAtIndex:self.whoseTurn];
    
    if(player.isComputer){
        
    }
    
    NSString* cardString = [card jsonString];
    
    //write message to player
    [player.connection write: cardString  withType: msg];
}

- (void)handleDiscard:(NSData *)data
{
    // Nothing needed in this class
}

- (void)handleDrawCard
{
    // Nothing needed in this class
}

- (void)advanceTurn
{
    // Nothing needed in this class   
}

#pragma mark - ConnectionDelegate

- (void)outputStreamOpened:(WifiConnection *)connection
{
    //TODO, not sure what todo
}

- (void)outputStreamClosed:(WifiConnection *)connection
{
    [self.game dropPlayer:connection.connectionId];
}

- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int)type
{
    // Nothing needed in this class
}

- (void)startComputerTurn
{
    // Nothing needed in this class 
}

- (void)declareWinner:(int)winner
{
    //TODO declare winner on gameboard
    [self.delegate declareWinner:((Player *)[self.game.players objectAtIndex:winner]).name];
    
    int i = 0;
    for (Player * p in self.game.players) {
        if(i == winner){
            [p.connection write: @""  withType: MSG_WINNER];
        } else {
            [p.connection write: @""  withType: MSG_LOSER];
        }
        i++;
    }
    
    
    //TODO quit game
}

- (void)refreshPlayers
{
    int i = 0;
    for (Player * p in self.game.players) {
        [p.connection write:[p jsonString:i == self.whoseTurn] withType:MSG_REFRESH];
        i++;
    }
}




@end
