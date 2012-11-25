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

- (void) setupGameboard {
    //add players
    
    //get connections
    
    //deal cards
    [self.game setup];
    
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
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
   
    if (type == MSG_PLAY_CARD){
        //discard card on game board
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_DRAW_CARD){
        //draw card for player
        [self handleDrawCard];
        [self advanceTurn];
        
    } else if(type == MSG_REFRESH){
        
        
        
    } else if(type == MSG_PLAY_EIGHT_C){
        //TODO move to C8 gamecontroller
        self.suitChosen = SUIT_CLUBS;
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_PLAY_EIGHT_D){
        self.suitChosen = SUIT_DIAMONDS;
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_PLAY_EIGHT_H){
        self.suitChosen = SUIT_HEARTS;
        [self handleDiscard:d];
        [self advanceTurn];
        
    } else if(type == MSG_PLAY_EIGHT_S){
        self.suitChosen = SUIT_SPADES;
        [self handleDiscard:d];
        [self advanceTurn];
        
    }
    
    
    
    //playercontroller code for reference
    /*// If this is the init message
    if (type == NSIntegerMax) {
        self.isTurn = NO;
        [self.delegate gameDidBegin];
    } else if (type == MSG_SETUP) {
        // Setup
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *t in jsonObject) {
            [arr addObject:[Card cardWithValues:t]];
        }
        
        self.hand = arr;
        [self.delegate playerHandDidChange];
    } else if (type == MSG_IS_TURN) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        [self handleIsTurn:jsonObject];
        
        self.isTurn = YES;
    } else if (type == MSG_CARD_DRAWN) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        
        [self.hand addObject:[Card cardWithValues:jsonObject]];
        [self.delegate playerHandDidChange];
    } else if (type == MSG_WINNER) {
        [self.delegate playerDidWin];
    } else if (type == MSG_LOSER) {
        [self.delegate playerDidLose];
    } else if (type == MSG_REFRESH) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        // name...?
        [self handleIsTurn:[jsonObject objectForKey:@"discardCard"]];
        
        for (NSDictionary *t in [jsonObject objectForKey:@"currenthand"]) {
            [arr addObject:[Card cardWithValues:t]];
        }
        
        self.hand = [arr mutableCopy];
        self.isTurn = [[jsonObject objectForKey:@"isturn"] boolValue];
        [self.delegate playerHandDidChange];
    } else if (type == MSG_PAUSE) {
        [self.delegate gameDidPause];
    } else if (type == MSG_UNPAUSE) {
        [self.delegate gameDidResume];
    }*/
}

- (void)startComputerTurn
{
    // Nothing needed in this class 
}






@end
