//
//  CrazyEightsTabletGame.m
//  CardGames
//
//  Created by Jamie Kujawa on 11/11/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "CrazyEightsTabletGame.h"

@implementation CrazyEightsTabletGame

-(void) addPlayer: (Player*)p {
    [self.players addObject:p];
}

-(int) getNumberOfPlayers{
    return [self.players count];
}

-(BOOL) isGameOver: (Player*)p{
    if([p.cards count] == 0){
        return true;
    }
    return false;
}

-(void) discard: (Player*)p : withCard: (Card*) c{
    [self.discardPile addObject:c];
    [p.cards removeObject:c];
}

-(Card*) getDiscardPileTop{
    return [self.discardPile objectAtIndex:[self.discardPile count]-1];
}

-(void) dropPlayer: (NSString*)macAddress{
    
    Player* p = nil;
    
    for(Player* player in self.players){
        if(player.connection == macAddress){
            p = player;
            break;
        }
    }
    
    
    //TODO add computer player when player is dropped
    
    if(p != nil){
        [self.players removeObject:p];
    }
}

@end
