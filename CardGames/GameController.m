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

- (void)handleSegue:(UIStoryboardSegue *)segue
             sender:(id)sender
{
    //TODO this is where the game is setup based on info from the connect view controller
   
}

- (void) setupGameboardWithPlayers:(NSMutableArray *) players {

    
    
    
    //add players
    
    //get connections
    
    //deal cards
    [self.game setup];
    
    //counter to tell which player index
    int i = 0;
    
    
    //get computer difficulty
    NSString *compDifficulty = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"computerDifficulty"];
    
    
    //send cards to players
    for (Player* p in self.game.players) {
        //make this class recieve messages from each connection
        p.connection.delegate = self;
        
        //send cards
        [p.connection write:[p jsonString:(self.whoseTurn == i)] withType:MSG_SETUP];
        
        i++;
    }
    NSLog(@"Number of Players %d", i);
    
    Card* onDiscard = [self.game getDiscardPileTop];
    
    //send first turn
    [self sendCard: onDiscard withTurnCode:MSG_IS_TURN toPlayerIndex:self.whoseTurn];
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
    //TODO open up reconnection screen
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
            [p.connection write: nil  withType: MSG_WINNER];
        } else {
            [p.connection write: nil  withType: MSG_LOSER];
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
