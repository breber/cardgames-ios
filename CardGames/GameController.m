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
#import "Constants.h"

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
    
    
    
    
    //send first turn
    [self sendTurnCode:MSG_IS_TURN toPlayerIndex:self.whoseTurn];
}

- sendTurnCode:(int) msg toPlayerIndex:(int) index{
    //get the player
    Player* player = [self.game.players objectAtIndex:self.whoseTurn];
    
    NSString* cardString = [self.game getNextCard];
    
    //write message to player
    [player.connection write: cardString  withType: msg];
}

- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int)type
{
 //TODO handle incoming messages
    
    
    
}







@end
