//
//  CrazyEightsPlayerController.m
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIColor+CardGamesColor.h"
#import "C8Constants.h"
#import "Constants.h"
#import "CrazyEightsPlayerController.h"
#import "CrazyEightsRules.h"
#import "RoundedButton.h"

@interface CrazyEightsPlayerController()
@property(nonatomic, strong) Card *discardCard;
@end

@implementation CrazyEightsPlayerController

- (void)setIsTurn:(BOOL)isTurn
{
    [super setIsTurn:isTurn];

    for (UIView* button in [self.buttonView subviews]) {
        if ([button isMemberOfClass:[UIButton class]]) {
            UIButton *b = (UIButton *)button;

            if (isTurn) {
                b.backgroundColor = [UIColor goldColor];
            } else {
                b.backgroundColor = [UIColor blackColor];
            }
            
            b.enabled = isTurn;
        }
    }
}

- (BOOL)canPlay:(Card *)card
{
    return [CrazyEightsRules canPlay:card withDiscard:self.discardCard];
}

- (void)handleIsTurn:(NSDictionary *)data
{
    [super handleIsTurn:data];

    self.discardCard = [Card cardWithValues:data];
}

- (void)handleSegue:(UIStoryboardSegue *)segue
             sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"choosesuit"]) {
		ChooseSuitViewController *chooseSuitViewController = segue.destinationViewController;
		chooseSuitViewController.delegate = self;
	}
}

- (void)addButtons:(UIView *)wrapper
{
    self.buttonView = wrapper;
    UIButton *drawButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 37)];
    drawButton.backgroundColor = [UIColor blackColor];
    [drawButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [drawButton setTitleColor:[UIColor goldColor] forState:UIControlStateDisabled];
    [drawButton setTitle:@"Draw" forState:UIControlStateNormal];
    [drawButton addTarget:self action:@selector(drawButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [drawButton setEnabled:NO];
    [drawButton.layer setMasksToBounds:true];
    [drawButton.layer setCornerRadius:4.0f];
    [drawButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [drawButton.layer setBorderWidth:1.0f];

    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width - 160, 0, 160, 37)];
    playButton.backgroundColor = [UIColor blackColor];
    [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor goldColor] forState:UIControlStateDisabled];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [playButton setEnabled:NO];
    [playButton.layer setMasksToBounds:true];
    [playButton.layer setCornerRadius:4.0f];
    [playButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [playButton.layer setBorderWidth:1.0f];
    
    [self.buttonView addSubview:drawButton];
    [self.buttonView addSubview:playButton];
}

- (void)drawButtonPressed
{
    if (self.isTurn) {
        [self.connection write:@"" withType:MSG_DRAW_CARD];
        self.isTurn = NO;
    }
}

- (void)playButtonPressed
{
    if (self.isTurn) {
        int selected = [self.delegate getSelectedCardIndex];

        if (selected >= 0) {
            Card *c = [self.hand objectAtIndex:selected];
            
            if ([CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
                if (c.value == CARD_EIGHT) {
                    [self.delegate showNewScreen:@"choosesuit"];
                } else {
                    // Send the card
                    [self.connection write:[c jsonString] withType:MSG_PLAY_CARD];
                    
                    // Remove the card from our hand
                    [self.hand removeObjectAtIndex:selected];
                    [self.delegate playerHandDidChange];
                    
                    // Set that it isn't our turn anymore
                    self.isTurn = NO;
                }
            }
        }
    }
}

- (void)handleChooseSuit:(int)suit
{
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
        int selected = [self.delegate getSelectedCardIndex];
        
        if (selected >= 0) {
            Card *c = [self.hand objectAtIndex:selected];
            
            if ([CrazyEightsRules canPlay:c withDiscard:self.discardCard]) {
                // Send the card
                [self.connection write:[c jsonString] withType:type];
                
                // Remove the card from our hand
                [self.hand removeObjectAtIndex:selected];
                [self.delegate playerHandDidChange];
                
                // Set that it isn't our turn anymore
                self.isTurn = NO;
            }
        }
    }
}

@end
