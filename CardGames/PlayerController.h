//
//  PlayerController.h
//  CardGames
//
//  Created by Brian Reber on 9/14/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionListener.h"
#import "Rules.h"
#import "WifiConnection.h"

@protocol PlayerControllerDelegate <NSObject>

- (void)gameDidPause;
- (void)gameDidResume;
- (void)playerDidWin;
- (void)playerDidLose;
- (void)playerTurnDidChange:(BOOL)withTurn;
- (void)playerHandDidChange;
- (NSIndexPath *)getSelectedCardIndex;
- (void)showNewScreen:(NSString *)viewController;
- (void)dismissScreen;

@end

@interface PlayerController : NSObject <ConnectionListener> {
    WifiConnection *connection;
}

@property(nonatomic, weak) id <PlayerControllerDelegate> delegate;
@property(nonatomic) BOOL isTurn;
@property(nonatomic, strong) NSMutableArray *hand;
@property(nonatomic, strong) Rules *rules;
@property(nonatomic, weak) UIView *buttonView;

- (void)handleIsTurn:(NSDictionary *)data;
- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)addButtons:(UIView *)wrapper;

@end
