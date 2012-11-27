//
//  GameBoardViewController.h
//  CardGames
//
//  Created by Ashley Nelson on 11/18/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "GameController.h"
#import "ViewController.h"
#import "CrazyEightsGameController.h"

// Game Board Constants
static const float GB_CARD_SCALE = 0.4;
static const float GB_CARD_OVERLAP = 1.0/3.0;

@interface GameBoardViewController : ViewController <GameControllerDelegate>

// Views
@property(nonatomic, strong) IBOutletCollection(UIView) NSArray *playerPositions;
@property(nonatomic, weak) IBOutlet UIImageView *discardPile;
@property(nonatomic, weak) IBOutlet UIImageView *drawPile;
@property(nonatomic, weak) IBOutlet UIButton *refreshButton;
@property(nonatomic, weak) IBOutlet UIButton *suitImage;
@property(nonatomic, weak) IBOutlet UIButton *pauseButton;

// Objects to maintain state
@property(nonatomic, strong) NSMutableArray *players;
@property(nonatomic, strong) GameController *gameController;

// Public Methods
- (void)setupGameController;

@end
