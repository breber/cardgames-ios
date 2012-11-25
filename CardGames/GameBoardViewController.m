//
//  GameBoardViewController.m
//  CardGames
//
//  Created by Ashley Nelson on 11/18/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "GameBoardViewController.h"
#import "CrazyEightsGameController.h" 
#import "GameResultViewController.h"

@interface GameBoardViewController ()

@end

@implementation GameBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupGameController
{
    self.gameController = [[CrazyEightsGameController alloc] init];
    self.gameController.delegate = self;
    [self.gameController setupGameboardWithPlayers:self.players];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // sort IBOutletCollection
	self.playerPositions = [self sortByObjectTag:self.playerPositions];
    
    // set up player hands
    self.player1Cards = [[NSMutableArray alloc] init];
    self.player2Cards = [[NSMutableArray alloc] init];
    self.player3Cards = [[NSMutableArray alloc] init];
    self.player4Cards = [[NSMutableArray alloc] init];
    self.playerHands = [[NSArray alloc] initWithObjects:self.player1Cards, self.player2Cards, self.player3Cards,
                        self.player4Cards, nil];
    
    for (int i = 1; i < self.playerHands.count; i++)
    {
        [self rotateView:i];
    }
    
    /*
    NSDictionary *cardValues = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"suit", @"15", @"id", @"3", @"value", nil];
    Card *tempCard = [Card cardWithValues:cardValues];
    
    cardValues = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"suit", @"17", @"id", @"5", @"value", nil];
    Card *tempCard2 = [Card cardWithValues:cardValues];
    
    [self addCard:tempCard toPlayer:0];
    [self addCard:tempCard toPlayer:0];
    [self addCard:tempCard toPlayer:1];
    [self addCard:tempCard toPlayer:1];
    [self addCard:tempCard toPlayer:2];
    //[self addCard:tempCard toPlayer:2];
    [self addCard:tempCard toPlayer:3];
    [self addCard:tempCard toPlayer:3];
    
    [self addCard:tempCard2 toPlayer:0];
    [self addCard:tempCard2 toPlayer:0];
    [self addCard:tempCard2 toPlayer:1];
    [self addCard:tempCard2 toPlayer:1];
    [self addCard:tempCard2 toPlayer:2];
    [self addCard:tempCard2 toPlayer:2];
    [self addCard:tempCard2 toPlayer:3];
    [self addCard:tempCard2 toPlayer:3];
    
    [self removeCard:tempCard fromPlayer:2];
    
    [self changeDiscardImage:[tempCard cardImagePath]];
    [self changeDrawImage:[tempCard2 cardImagePath]];
     */
    
    //player1.bounds = CGRectMake(0, 0, (player1.subviews.count-1)*img.size.width*2/15 + img.size.width*2/5, img.size.height/10);
}

- (void)gameRequestingName
{
    //TODO
    
}

- (void)gameDidBegin
{
    //TODO
    
}

- (void)gameDidPause
{
    //TODO
    
}
- (void)gameDidResume
{
    //TODO
    
}

- (void)declareWinner:(NSString *)winner
{    
    [self performSegueWithIdentifier:@"declarewinner" sender:winner];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(segue.identifier == @"declarewinner"){
        ((GameResultViewController *)segue.destinationViewController).title = sender;
    }
}

- (void)addCard:(Card *)card toPlayer:(int)playerNumber
{
    NSMutableArray *tempPlayerHand = self.playerHands[playerNumber];
    [tempPlayerHand addObject:card];
    
    [self drawCard:card toPlayer:playerNumber atIndex:[tempPlayerHand count] - 1];
}

- (void)removeCard:(Card *)card fromPlayer:(int)playerNumber
{
    NSMutableArray *tempPlayerHand = self.playerHands[playerNumber - 1];
    [tempPlayerHand removeObject:card];
    
    [self redrawCardsForPlayer:playerNumber];
}

- (void)changeDiscardImage:(NSString *)imagePath
{
    UIImage *img = [UIImage imageNamed:imagePath];
    [self.discardPile setImage:img];
}

- (void)changeDrawImage:(NSString *)imagePath
{
    UIImage *img = [UIImage imageNamed:imagePath];
    [self.drawPile setImage:img];
}

- (void)drawCard:(Card *)card toPlayer:(int)playerNumber atIndex:(int)cardIndex
{
    UIView *tempView = self.playerPositions[playerNumber];
    
    UIImage *img = [UIImage imageNamed:[card cardImagePath]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((img.size.width * GB_CARD_SCALE * GB_CARD_OVERLAP) *
                                                                         cardIndex, 0, img.size.width * GB_CARD_SCALE,
                                                                         img.size.height * GB_CARD_SCALE)];
    [imgView setImage:img];
    [tempView addSubview:imgView];
}

- (void)redrawCardsForPlayer:(int)playerNumber
{
    UIView *tempView = self.playerPositions[playerNumber];
    
    // Remove all card views
    for (UIImageView *i in tempView.subviews) {
        [i removeFromSuperview];
    }
    
    NSMutableArray *tempPlayerHand = self.playerHands[playerNumber];
    
    // Replace all card views
    for (int j = 0; j < tempPlayerHand.count; j++)
    {
        [self drawCard:tempPlayerHand[j] toPlayer:playerNumber atIndex:j];
    }
}

- (void)rotateView:(int)playerNumber
{
    UIView *currentPlayerView = self.playerPositions[playerNumber];
    
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeRotation(-90 * playerNumber / 180.0 * M_PI);
    currentPlayerView.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

- (NSArray *)sortByObjectTag:(NSArray *)arr
{
    return [arr sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB) {
        return (
                ([objA tag] < [objB tag]) ? NSOrderedAscending  :
                ([objA tag] > [objB tag]) ? NSOrderedDescending :
                NSOrderedSame);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
