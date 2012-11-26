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

static const int ACE_VALUE = 0;
static const int TWO_VALUE = 1;
static const int THREE_VALUE = 2;
static const int FOUR_VALUE = 3;
static const int FIVE_VALUE = 4;
static const int SIX_VALUE = 5;
static const int SEVEN_VALUE = 6;
static const int EIGHT_VALUE = 7;
static const int NINE_VALUE = 8;
static const int TEN_VALUE = 9;
static const int JACK_VALUE = 10;
static const int QUEEN_VALUE = 11;
static const int KING_VALUE = 12;
static const int BLACK_JOKER_VALUE = 0;
static const int RED_JOKER_VALUE = 1;

static const int NUMBER_OF_CARDS_PER_HAND = 5;

static const NSString * DIF_COMP_EASY = @"easy";
static const NSString * DIF_COMP_MEDIUM = @"medium";
static const NSString * DIF_COMP_HARD = @"hard";

static NSString *BONJOUR_SERVICE = @"_cardgames._tcp.";
static NSString *DEFAULT_NAME = @"Anonymous";

#endif
