//
//  PlayerController.m
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayerController.h"
#import "Constants.h"
#import "SBJson.h"

@implementation PlayerController

@synthesize hand = _hand;
@synthesize rules = _rules;
@synthesize buttonView = _buttonView;

- (id) init {
    self = [super init];
    
    if (self) {
        connection = [WifiConnection sharedInstance];
        connection.listener = self;
        
        self.isTurn = NO;
    }

    return self;
}

- (void)setIsTurn:(BOOL)isTurn {
    _isTurn = isTurn;
    [self.delegate playerTurnDidChange:self.isTurn];
}

- (void) outputStreamOpened {
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *result = [textField text];
    
    NSLog(@"alertView: %@", [alertView title]);
    
    if ([[alertView title] isEqualToString:@"Enter Name"]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: result, @"playername", nil];
        [connection write:[dict JSONRepresentation] withType:MSG_PLAYER_NAME];
    }
}

- (void) newDataArrived:(NSString *)data withType:(int) type {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    // If this is the init message
    if (type == NSIntegerMax) {
        self.isTurn = NO;
        // TODO: stop spinner or something indicating we are ready
    } else if (type == MSG_SETUP) {
        // Setup
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
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
        
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
        [self handleIsTurn:jsonObject];
    } else if (type == MSG_CARD_DRAWN) {
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
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
        // TODO: handle refresh
    } else if (type == MSG_PAUSE) {
        [self.delegate gameDidPause];
    } else if (type == MSG_UNPAUSE) {
        [self.delegate gameDidResume];
    }
}

- (void)handleIsTurn:(NSDictionary *)data {
    // Nothing needed in this class
}

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Nothing needed in this class
}

- (void)addButtons:(UIView *)wrapper {
    // Nothing needed in this class
}

@end
