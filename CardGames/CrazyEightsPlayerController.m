//
//  CrazyEightsPlayerController.m
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Constants.h"
#import "CrazyEightsPlayerController.h"
#import "CrazyEightsRules.h"

@interface CrazyEightsPlayerController()

@property(nonatomic, strong) Card *discardCard;

@end

@implementation CrazyEightsPlayerController

- (id)init {
    self = [super init];
    
    if (self) {
        self.discardCard = nil;
    }
    
    return self;
}

- (void)handleIsTurn:(NSDictionary *)data {
    [super handleIsTurn:data];
    
    NSLog(@"handleIsTurn");
    
    Card *c = [[Card alloc] init];
    c.value = [[data objectForKey:@"value"] intValue];
    c.suit = [[data objectForKey:@"suit"] intValue];
    c.cardId = [[data objectForKey:@"id"] intValue];
    
    self.discardCard = c;
}

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"choosesuit"]) {
		ChooseSuitViewController *chooseSuitViewController = segue.destinationViewController;
		chooseSuitViewController.delegate = self;
	}
}

- (IBAction) drawButtonPressed {
    if (self.isTurn) {
        [connection write:@"" withType:MSG_DRAW_CARD];
        self.isTurn = NO;
        [self.delegate playerTurnDidChange:self.isTurn];
    }
}

- (IBAction) playButtonPressed {
    if (self.isTurn) {
        NSIndexPath *selected = [self.delegate getSelectedCardIndex];
        
        if (selected) {
            Card *c = [self.hand objectAtIndex:selected.row];
            
            // TODO: check if 8
            if ([CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
                if (c.value == CARD_EIGHT) {
                    [self.delegate showNewScreen:@"choosesuit"];
                } else {
                    // Send the card
                    [connection write:[c jsonString] withType:MSG_PLAY_CARD];
                    
                    // Remove the card from our hand
                    [self.hand removeObjectAtIndex:selected.row];
                    [self.delegate playerHandDidChange];
                    
                    // Set that it isn't our turn anymore
                    self.isTurn = NO;
                    [self.delegate playerTurnDidChange:self.isTurn];
                }
            }
        }
    }
}

- (void)handleChooseSuit:(int)suit {
    [self.delegate dismissScreen];
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
        NSIndexPath *selected = [self.delegate getSelectedCardIndex];
        
        if (selected) {
            Card *c = [self.hand objectAtIndex:selected.row];
            
            if ([CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
                // Send the card
                [connection write:[c jsonString] withType:type];
                
                // Remove the card from our hand
                [self.hand removeObjectAtIndex:selected.row];
                [self.delegate playerHandDidChange];
                
                // Set that it isn't our turn anymore
                self.isTurn = NO;
                [self.delegate playerTurnDidChange:self.isTurn];
            }
        }
    }
}

@end
