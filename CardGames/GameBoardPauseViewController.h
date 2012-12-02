//
//  GameBoardPauseViewController.h
//  CardGames
//
//  Created by Brian Reber on 12/1/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameBoardPauseDelegate <NSObject>

- (void)gameShouldResume;
- (void)gameShouldEnd;

@end

@interface GameBoardPauseViewController : UIViewController

@property(nonatomic, weak) id <GameBoardPauseDelegate> delegate;

@end
