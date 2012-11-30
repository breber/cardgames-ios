//
//  CrazyEightsTabletGame.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "C8Constants.h"
#import "Constants.h"
#import "CrazyEightsTabletGame.h"
#import "WifiConnection.h"

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
    self.discardPile = [[NSMutableArray alloc]init];
    [self.discardPile addObject:[self getNextCard]];
    
}

- (void)dealCards
{
    for (int i = 0; i < C8_CARDS_PER_HAND; i++) {
        for (Player *p in self.players) {
            [p.cards addObject:[self getNextCard]];
        }
    }
}

- (void)addCard:(Card *)card toDiscardPileFromPlayer:(Player *)player
{
    [self.discardPile addObject: card];
    
    for (int i = 0; i < [player.cards count]; i++) {
        Card *c = [player.cards objectAtIndex:i];
        
        if ([c isEqualToCard:card]) {
            [player.cards removeObjectAtIndex:i];
            break;
        }
    }
}

- (Card *)drawCardForPlayer:(Player *)player
{
    Card *cardDrawn = [self getNextCard];
    
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

+ (NSString *)getComputerDifficultyFromPicker
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *difficulty = [defaults objectForKey:PREF_DIFFICULTY];
    
    if (difficulty)  {
        return difficulty;
    }
    
    [defaults setObject:DIF_COMP_EASY forKey:PREF_DIFFICULTY];
    
    // This return may happen if the user default for the device is nil
    return DIF_COMP_EASY;
}

+ (int)getNumberOfComputerPlayersFromPicker
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *numComputers = [defaults objectForKey:PREF_NUM_COMPUTERS];

    if ([numComputers isEqualToString:@"One"]) {
        return 1;
    } else if ([numComputers isEqualToString:@"Two"]) {
        return 2;
    } else if ([numComputers isEqualToString:@"Three"]) {
        return 3;
    }
    
    [defaults setObject:@"One" forKey:PREF_NUM_COMPUTERS];

    // This return may happen if the user default for the device is nil
    return 1;
}

@end
