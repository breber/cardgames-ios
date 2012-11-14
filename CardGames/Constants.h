//
//  Constants.h
//  CardGames
//
//  Created by Brian Reber on 9/10/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#ifndef CardGames_Constants_h
#define CardGames_Constants_h

static const int MSG_SETUP = 0;
static const int MSG_IS_TURN = 1;
static const int MSG_CARD_DRAWN = 2;
static const int MSG_WINNER = 3;
static const int MSG_LOSER = 4;
static const int MSG_REFRESH = 5;
static const int MSG_PAUSE = 6;
static const int MSG_UNPAUSE = 7;
static const int MSG_PLAY_CARD = 9;
static const int MSG_DRAW_CARD = 10;
static const int MSG_PLAYER_NAME = 12;

static const int SUIT_CLUBS = 0;
static const int SUIT_DIAMONDS = 1;
static const int SUIT_HEARTS = 2;
static const int SUIT_SPADES = 3;
static const int SUIT_JOKER = 4;
static const int CARD_EIGHT = 7;

static NSString *DEFAULT_NAME = @"Anonymous";

#endif
