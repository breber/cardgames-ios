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

// TODO: make some of these optional
- (void)gameRequestingName;
- (void)gameDidBegin;
- (void)gameDidPause;
- (void)gameDidResume;
- (void)gameDidEnd;
- (void)playerDidWin;
- (void)playerDidLose;
- (void)playerTurnDidChange:(BOOL)withTurn;
- (void)playerHandDidChange;
- (NSIndexPath *)getSelectedCardIndex;
- (void)showNewScreen:(NSString *)viewController;
- (void)dismissScreen;

@end

@interface PlayerController : NSObject

@property(nonatomic, weak) id <PlayerControllerDelegate> delegate;
@property(nonatomic, strong) WifiConnection *connection;
@property(nonatomic) BOOL isTurn;
@property(nonatomic, strong) NSMutableArray *hand;
@property(nonatomic, weak) UIView *buttonView;

- (void)setName:(NSString *)name;
- (void)handleIsTurn:(NSDictionary *)data;
- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)addButtons:(UIView *)wrapper;

@end
