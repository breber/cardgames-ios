//
//  GameController.m
//  CardGames
//
//  Created by Peters, Joshua on 11/16/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Constants.h"
#import "GameController.h"
#import "Player.h"

@interface GameController() <ConnectionDelegate>

@end

@implementation GameController

- (id)init
{
    self = [super init];
    
    if (self) {
        self.whoseTurn = 0;
        self.game = [CrazyEightsTabletGame sharedInstance];
        
        
    }
    
    return self;
}

- (void)addButtons
{
    //TODO
    //add refresh
    
    //add pause
}

- (void)setupGameboardWithPlayers:(NSMutableArray *) players
{
    //add players
    self.game.players = players;
    
    int numHumans = [players count];
    
    // Get computer difficulty setting
    NSString *compDifficulty = [CrazyEightsTabletGame getComputerDifficultyFromPicker];
    
    // Get number of computers setting
    int numComputers = [CrazyEightsTabletGame getNumberOfComputerPlayersFromPicker];
    
    // TODO: make this based on number of computers specified
    for (int i = 0; i < 4 && i < numHumans + numComputers; i++) {
        if (i < numHumans) {
            Player *p = (Player *)[players objectAtIndex:i];
            p.isComputer = NO;
            p.computerDifficulty = compDifficulty;
            p.cards = [[NSMutableArray alloc] init];
        } else {
            Player *player = [[Player alloc] init];
            player.connection = nil;
            player.name = [NSString stringWithFormat:@"Computer %i", i - numHumans + 1];
            player.isComputer = YES;
            player.computerDifficulty = compDifficulty;
            player.cards = [[NSMutableArray alloc] init];
            
            [self.game addPlayer:player];
        }
    }
    
    // Deal cards
    [self.game setup];
    
    // Let the view controller go 
    [self.delegate refreshGameBoard];
    
    //counter to tell which player index
    int i = 0;
    
    // Send cards to players
    for (Player* p in self.game.players) {
        // make this class recieve messages from each connection
        p.connection.delegate = self;
        
        // Send the INIT message
        [p.connection write:@"" withType:MSG_INIT];
        
        // send cards
        NSData *data = [NSJSONSerialization dataWithJSONObject:[p jsonCards] options:kNilOptions error:nil];
        NSString *toWrite = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [p.connection write:toWrite withType:MSG_SETUP];
        
        i++;
    }

    NSLog(@"Number of Human Players: %d, Computer Players: %d", numHumans, i - numHumans);

    // Start first turn after 1 second (so that the messages are sent separately
    [self performSelector:@selector(startFirstTurn) withObject:self afterDelay:1];
}

- (void)startFirstTurn
{
    // Nothing needed in this class
}

- (void)sendCard:(Card *)card
    withTurnCode:(int)msg
   toPlayerIndex:(int)index
{
    // get the player
    Player *player = [self.game.players objectAtIndex:self.whoseTurn];
    
    if (player.isComputer) {
        NSLog(@"%s - computerPlayer...", __PRETTY_FUNCTION__);
    }
    
    NSString *cardString = [card jsonString];
    
    // write message to player
    [player.connection write:cardString  withType:msg];
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

- (int) getSuit
{
    // Nothing needed in this class
    return 0;
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
    NSString * winnerName = [NSString stringWithFormat:@"%@ wins!", ((Player *)[self.game.players objectAtIndex:winner]).name];
    //TODO declare winner on gameboard
    [self.delegate declareWinner:winnerName];
    
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
        [p.connection write:[p jsonString:(i == self.whoseTurn) withDiscard:[self.game getDiscardPileTop]] withType:MSG_REFRESH];
        i++;
    }
}




@end
