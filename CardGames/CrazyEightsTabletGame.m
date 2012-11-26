//
//  CrazyEightsTabletGame.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsTabletGame.h"
#import "WifiConnection.h"
#import "Constants.h"

@interface CrazyEightsTabletGame()

@property(nonatomic, strong) NSMutableArray *discardPile;

@end

@implementation CrazyEightsTabletGame

static CrazyEightsTabletGame *instance = nil;

+ (CrazyEightsTabletGame *)sharedInstance
{
    if (instance == nil) {
        instance = [[CrazyEightsTabletGame alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.players = [[NSMutableArray alloc]init];
        self.deck = [[Deck alloc] init];
    }
    
    return self;
}

- (void)addPlayer:(Player *)p
{
    [self.players addObject:p];
}

- (BOOL)isGameOver:(Player *)p
{
    return [p.cards count] == 0;
}

- (void)setup
{
    [self.deck createDeck];
    self.shuffledDeck = [Deck shuffleArray:[self.deck deck]];
   
    self.e = [self.shuffledDeck objectEnumerator];
    [self dealCards];
    
}

- (void)dealCards
{
    for (int i = 0; i < NUMBER_OF_CARDS_PER_HAND; i++) {
        for (Player *p in self.players) {
            [p.cards addObject:[self getNextCard]];
        }
    }
}

- (void)addCard:(Card *)card toDiscardPileFromPlayer:(Player *)player
{
    [self.discardPile addObject: card];
    [player.cards removeObject: card];
}

- (Card *) drawCardForPlayer:(Player *) player
{
    Card * cardDrawn = [self getNextCard];
    
    [player.cards addObject:cardDrawn];
    
    return cardDrawn;
}

- (void)addCardsFromDiscardPileToShuffledDeck
{
    Card *c = [self getDiscardPileTop];
    [self.discardPile removeObject:c];
    self.e = nil;
    [self.shuffledDeck addObjectsFromArray:self.discardPile];
    [self.discardPile removeAllObjects];
    [self.discardPile addObject:c];
    [Deck shuffleArray:self.discardPile];
    self.e = [self.shuffledDeck objectEnumerator];
}

- (Card *)getNextCard
{
    Card *c = [self.e nextObject];
    // TODO: fix this
//    [self.shuffledDeck removeObject:c];
    return c;
}

- (Card *)getDiscardPileTop
{
    return [self.discardPile lastObject];
}

- (void)dropPlayer:(NSString *)connectionId
{
    Player *p = nil;
    
    for (Player *player in self.players) {
        if ([player.connection connectionId] == connectionId) {
            p = player;
            break;
        }
    }    
    
    // Set player as a computer
    if (p) {
        p.isComputer = YES;
    }
}

+ (int) getNumberOfComputerPlayersFromPicker{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *myString = [defaults objectForKey:@"numberOfComputers"];
    
    if ([myString isEqualToString:@"One"]) {
        return 1;
    } else if ([myString isEqualToString:@"Two"]) {
        return 2;
    } else if ([myString isEqualToString:@"Three"]) {
        return 3;
    }
    
    [defaults setObject:@"One" forKey:@"numberOfComputers"];

    //This return may happen if the user default for the device is nil
    return 1;
}

@end
