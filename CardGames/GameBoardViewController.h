//
//  GameBoardViewController.h
//  CardGames
//
//  Created by Ashley Nelson on 11/18/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

// Game Board Constants
static const float GB_CARD_SCALE = 0.4;
static const float GB_CARD_OVERLAP = 1.0/3.0;

@interface GameBoardViewController : UIViewController

// Views
@property(nonatomic, strong) IBOutletCollection(UIView) NSArray *playerPositions;
@property(nonatomic, weak) IBOutlet UIImageView *discardPile;
@property(nonatomic, weak) IBOutlet UIImageView *drawPile;

// Objects to maintain state
@property(nonatomic, strong) NSMutableArray *player1Cards;
@property(nonatomic, strong) NSMutableArray *player2Cards;
@property(nonatomic, strong) NSMutableArray *player3Cards;
@property(nonatomic, strong) NSMutableArray *player4Cards;
@property(nonatomic, strong) NSArray *playerHands;

// Methods
- (void)addCard:(Card *)card toPlayer:(int)playerNumber;
- (void)removeCard:(Card *)card fromPlayer:(int)playerNumber;
- (void)changeDiscardImage:(NSString *)imagePath;
- (void)changeDrawImage:(NSString *)imagePath;

@end
