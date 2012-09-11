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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"choosesuit"]) {
		ChooseSuitViewController *chooseSuitViewController = segue.destinationViewController;
		chooseSuitViewController.delegate = self;
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
                } else {
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
}

- (void)handleChooseSuit:(int)suit {
    [self dismissViewControllerAnimated:YES completion:nil];
    int type = 0;
    
    switch (suit) {
        case SUIT_CLUBS:
            type = MSG_PLAY_EIGHT_C;
            break;
        case SUIT_DIAMONDS:
            type = MSG_PLAY_EIGHT_D;
            break;
        case SUIT_HEARTS:
            type = MSG_PLAY_EIGHT_H;
            break;
        case SUIT_SPADES:
            type = MSG_PLAY_EIGHT_S;
            break;
        default:
            break;
    }
    
    if (self.isTurn) {
        NSIndexPath *selected = [cardHand indexPathForSelectedRow];
        
        if (selected) {
            Card *c = [self.hand objectAtIndex:selected.row];
            
            if ([CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
                // Send the card
                [connection write:[c jsonString] withType:type];
                
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
        [cardHand reloadData];
    } else if (type == MSG_IS_TURN) {
        self.isTurn = YES;
        
        NSDictionary *jsonObject = [jsonParser objectWithString:data];
        Card *c = [[Card alloc] init];
        c.value = [[jsonObject objectForKey:@"value"] intValue];
        c.suit = [[jsonObject objectForKey:@"suit"] intValue];
        c.cardId = [[jsonObject objectForKey:@"id"] intValue];
        
        self.discardCard = c;
        
        [self toggleButtons];
    } else if (type == MSG_CARD_DRAWN) {
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
    } else if (type == MSG_REFRESH) {
        // TODO: handle refresh
    } else if (type == MSG_PAUSE) {
        [self performSegueWithIdentifier:@"pause" sender:self];
    } else if (type == MSG_UNPAUSE) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
