//
//  PlayerController.m
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayerController.h"
#import "Constants.h"
#import "Card.h"
#import "ConnectionDelegate.h"

@interface PlayerController() <ConnectionDelegate>

@end

@implementation PlayerController

- (id)init
{
    self = [super init];
    
    if (self) {
        self.connection = [WifiConnection sharedInstance];
        self.connection.delegate = self;
        
        self.isTurn = NO;
    }

    return self;
}

- (BOOL)canPlay:(Card *)card
{
    return YES;
}

- (void)setName:(NSString *)name
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: name, @"playername", nil];
    [self.connection writeDictionary:dict withType:MSG_PLAYER_NAME];
}

- (void)handleIsTurn:(NSDictionary *)data
{
    // Nothing needed in this class
}

- (void)handleSegue:(UIStoryboardSegue *)segue
             sender:(id)sender
{
    // Nothing needed in this class
}

- (void)addButtons:(UIView *)wrapper
{
    // Nothing needed in this class
}

- (void)setIsTurn:(BOOL)isTurn
{
    _isTurn = isTurn;
    [self.delegate playerTurnDidChange:self.isTurn];
}

#pragma mark - ConnectionDelegate

- (void)outputStreamOpened:(WifiConnection *)connection
{
    // Show a popup requesting the IP address of the server to connect to
    [self.delegate gameRequestingName];
}

- (void)outputStreamClosed:(WifiConnection *)connection
{
    // Clear the player's hand
    [self.hand removeAllObjects];
    
    [self.delegate gameDidEnd];
}

- (void)newDataArrived:(WifiConnection *)connection
              withData:(NSString *)data
              withType:(int)type
{
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
    // If this is the init message
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
    }
}

@end
