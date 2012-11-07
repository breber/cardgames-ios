//
//  CrazyEightsPlayerController.h
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ChooseSuitViewController.h"
#import "PlayerController.h"

@interface CrazyEightsPlayerController : PlayerController <ChooseSuit>

- (void)drawButtonPressed;
- (void)playButtonPressed;

@end
