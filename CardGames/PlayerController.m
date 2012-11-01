//
//  PlayerController.m
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayerController.h"
#import "Constants.h"

@implementation PlayerController

- (id) init
{
    self = [super init];
    
    if (self) {
        connection = [WifiConnection sharedInstance];
        connection.listener = self;
        
        self.isTurn = NO;
    }

    return self;
}

- (void)setIsTurn:(BOOL)isTurn
{
    _isTurn = isTurn;
    [self.delegate playerTurnDidChange:self.isTurn];
}

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

- (void)setName:(NSString *)name
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: name, @"playername", nil];
    [connection writeDictionary:dict withType:MSG_PLAYER_NAME];
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
            Card *c = [[Card alloc] init];
            c.value = [[t objectForKey:@"value"] intValue];
            c.suit = [[t objectForKey:@"suit"] intValue];
            c.cardId = [[t objectForKey:@"id"] intValue];
            
            [arr addObject:c];
        }
        
        self.hand = arr;
        [self.delegate playerHandDidChange];
    } else if (type == MSG_IS_TURN) {
        self.isTurn = YES;
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        [self handleIsTurn:jsonObject];
    } else if (type == MSG_CARD_DRAWN) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        Card *c = [[Card alloc] init];
        c.value = [[jsonObject objectForKey:@"value"] intValue];
        c.suit = [[jsonObject objectForKey:@"suit"] intValue];
        c.cardId = [[jsonObject objectForKey:@"id"] intValue];
        
        [self.hand addObject:c];
        [self.delegate playerHandDidChange];
    } else if (type == MSG_WINNER) {
        [self.delegate playerDidWin];
    } else if (type == MSG_LOSER) {
        [self.delegate playerDidLose];
    } else if (type == MSG_REFRESH) {
        // TODO: fix refresh after updating to use JSONObject with JSONArray
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:d options:kNilOptions error:nil];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        int loopCount = 0;
        
        for (NSDictionary *t in jsonObject) {
            if (loopCount > 1) {
                Card *c = [[Card alloc] init];
                c.value = [[t objectForKey:@"value"] intValue];
                c.suit = [[t objectForKey:@"suit"] intValue];
                c.cardId = [[t objectForKey:@"id"] intValue];
                
                [arr addObject:c];
            }
            
            loopCount++;
        }
        
        self.hand = arr;
        [self.delegate playerHandDidChange];
    } else if (type == MSG_PAUSE) {
        [self.delegate gameDidPause];
    } else if (type == MSG_UNPAUSE) {
        [self.delegate gameDidResume];
    }
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

@end
