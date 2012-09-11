//
//  PlayViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayViewController.h"
#import "Card.h"
#import "Constants.h"
#import "CrazyEightsRules.h"
#import "SBJson.h"

@interface PlayViewController ()

@property(nonatomic) BOOL isTurn;
@property(nonatomic, strong) Card *discardCard;

@end

@implementation PlayViewController

@synthesize isTurn = _isTurn;
@synthesize discardCard = _discardCard;
@synthesize hand = _hand;

- (void)viewDidLoad {
    [super viewDidLoad];

    connection = [WifiConnection sharedInstance];
    connection.listener = self;
    
    self.discardCard = nil;
    self.isTurn = NO;
        
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter IP Address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *result = [textField text];
    
    if ([[alertView title] isEqualToString:@"Enter IP Address"]) {
        [connection initNetworkCommunication:result];
    } else if ([[alertView title] isEqualToString:@"Enter Name"]) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: result, @"playername", nil];
        [connection write:[dict JSONRepresentation] withType:MSG_PLAYER_NAME];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) outputStreamOpened {
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (IBAction)playButtonPressed {
    if (self.isTurn) {
        NSIndexPath *selected = [cardHand indexPathForSelectedRow];
        
        if (selected) {
            Card *c = [self.hand objectAtIndex:selected.row];
            
            // TODO: check if 8
            if ([CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
                if (c.value == CARD_EIGHT) {
                    [self performSegueWithIdentifier:@"choosesuit" sender:self];
                }
                
                NSLog(@"after perform segue");
                
                // Send the card
                [connection write:[c jsonString] withType:MSG_PLAY_CARD];
                
                // Remove the card from our hand
                [self.hand removeObjectAtIndex:selected.row];
                [cardHand reloadData];
                
                // Set that it isn't our turn anymore
                self.isTurn = NO;
                [self toggleButtons];
            }
        }
    }
}

- (IBAction)drawButtonPressed {
    if (self.isTurn) {
        [connection write:@"" withType:MSG_DRAW_CARD];
        self.isTurn = NO;
        [self toggleButtons];
    }
}

- (void) newDataArrived:(NSString *)data withType:(int) type {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    // If this is the init message
    if (type == NSIntegerMax) {
        NSLog(@"App Init...");
    } else if (type == MSG_SETUP) {
        // Setup
        NSLog(@"MSG_SETUP");
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
        [cardHand reloadData];
    } else if (type == MSG_IS_TURN) {
        NSLog(@"MSG_IS_TURN");
        self.isTurn = YES;
        
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
        Card *c = [[Card alloc] init];
        c.value = [[jsonObject objectForKey:@"value"] intValue];
        c.suit = [[jsonObject objectForKey:@"suit"] intValue];
        c.cardId = [[jsonObject objectForKey:@"id"] intValue];
        
        self.discardCard = c;
        
        [self toggleButtons];
    } else if (type == MSG_CARD_DRAWN) {
        NSLog(@"MSG_CARD_DRAWN");
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
        Card *c = [[Card alloc] init];
        c.value = [[jsonObject objectForKey:@"value"] intValue];
        c.suit = [[jsonObject objectForKey:@"suit"] intValue];
        c.cardId = [[jsonObject objectForKey:@"id"] intValue];
        
        [self.hand addObject:c];
        [cardHand reloadData];
    } else if (type == MSG_WINNER) {
        [self performSegueWithIdentifier:@"winner" sender:self];
    } else if (type == MSG_LOSER) {
        [self performSegueWithIdentifier:@"loser" sender:self];
    }
}

- (void)toggleButtons {
    UIColor *goldColor = [UIColor colorWithRed:1 green:201 / 255.0 blue:14 / 255.0 alpha:1];

    if (self.isTurn) {
        drawButton.backgroundColor = goldColor;
        playButton.backgroundColor = goldColor;
    } else {
        drawButton.backgroundColor = [UIColor blackColor];
        playButton.backgroundColor = [UIColor blackColor];
    }
    
    playButton.enabled = self.isTurn;
    drawButton.enabled = self.isTurn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.hand count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *c = [self.hand objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    // Set the image of the cell
    UIImage *cardImage = [UIImage imageNamed:[c cardImagePath]];
    
    if (self.isTurn) {
        if (![CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
            // TODO: set background color
 
        }
    }
    
    [[cell imageView] setImage:cardImage];
    return cell;
}

@end
