//
//  PlayViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "Card.h"
#import "CenteredScrollView.h"
#import "Constants.h"
#import "CrazyEightsPlayerController.h"
#import "PlayViewController.h"
#import "UIColor+CardGamesColor.h"

@interface PlayViewController() <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UIView *buttonLayout;
@property(nonatomic, weak) IBOutlet UIView *overlay;
@property(nonatomic, weak) IBOutlet UITextField *textPopupTextField;
@property(nonatomic, weak) IBOutlet UIView *textPopup;
@property(nonatomic, weak) IBOutlet UIView *loadingPopup;
@property(nonatomic, weak) IBOutlet UILabel *loadingPopupTitle;
@property(nonatomic, weak) IBOutlet CenteredScrollView *cardHand;
@property(nonatomic, strong) PlayerController *playerController;
@property(nonatomic, strong) NSArray *cardButtons;

@end

@implementation PlayViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.playerController = [[CrazyEightsPlayerController alloc] init];
    self.playerController.delegate = self;

    // Hide the navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    // Show the keyboard
    [self.textPopupTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Add the game specific buttons
    [self.playerController addButtons:self.buttonLayout];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    [self.playerController handleSegue:segue sender:sender];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO: maybe check to see if the string is in the right format
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Save the player's name
    if ([[textField text] length]) {
        [self.playerController setName:[textField text]];
    } else {
        [self.playerController setName:DEFAULT_NAME];
    }
    
    [self.loadingPopupTitle setText:@"Waiting for game to begin..."];
    
    [self.textPopup setHidden:YES];
    [self.loadingPopup setHidden:NO];
}

#pragma mark - PlayerControllerDelegate

- (void)gameRequestingName
{
    [self.textPopupTextField becomeFirstResponder];

    [self.loadingPopup setHidden:YES];
    [self.textPopup setHidden:NO];
}

- (void)gameDidBegin
{
    [self.overlay setHidden:YES];
}

- (void)gameDidEnd
{
    // Dismiss the pause view controller if it exists
    [self dismissViewControllerAnimated:YES completion:nil];

    // Then go back to main menu
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)playerTurnDidChange:(BOOL)withTurn
{
    [self updatePlayableCards];
}

- (void)playerHandDidChange
{
    [self reloadData];
}

- (void)playerDidWin
{
    [self performSegueWithIdentifier:@"winner" sender:self];
}

- (void)playerDidLose
{
    [self performSegueWithIdentifier:@"loser" sender:self];
}

- (void)gameDidPause
{
    [self performSegueWithIdentifier:@"pause" sender:self];
}

- (void)gameDidResume
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self reloadData];
}

- (void)showNewScreen:(NSString *)viewController
{
    [self performSegueWithIdentifier:viewController sender:self];
}

- (void)dismissScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (int)getSelectedCardIndex
{
    int toRet = 0;
    for (UIButton *b in self.cardButtons) {
        if (b.tag == 1) {
            return toRet;
        }
        toRet++;
    }
    
    return -1;
}

#pragma mark - PlayViewController private

- (void)cardSelected:(UIButton *)sender
{
    for (UIButton *b in self.cardButtons) {
        b.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        b.tag = 0;
    }
    sender.backgroundColor = [UIColor goldColor];
    sender.tag = 1;
}

- (void)reloadData
{
    static double CARD_PADDING = 5;
    static double CARD_BORDER = 3;

    // Remove all of the cards from the scrollview
    for (UIButton *b in self.cardButtons) {
        [b removeFromSuperview];
    }

    for (UIView *v in self.cardHand.subviews) {
        [v removeFromSuperview];
    }

    // Create a new array for the buttons
    NSMutableArray *buttons = [NSMutableArray array];
    
    // Get the height of the scrollview
    CGFloat height = self.cardHand.frame.size.height;
    CGFloat width = 0;
    
    // For each card, add it to the scrollview
    int cardCount = self.playerController.hand.count;
    for (int i = 0; i < cardCount; i++) {
        Card *c = [self.playerController.hand objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:[c cardImagePath]];
        
        // If we haven't calculated a width for the cards,
        // do that now based on the aspect ratio of the image,
        // and the height of the scrollview
        if (!width) {
            CGFloat imageRatio = image.size.width / image.size.height;
            width = height * imageRatio;
        }
        
        // Set up the frame for the card
        CGRect frame;
        frame.origin.x = width * i + CARD_PADDING * i;
        frame.origin.y = 0;
        frame.size = CGSizeMake(width, height);

        // Set up the button that will be the card
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setImageEdgeInsets:UIEdgeInsetsMake(CARD_BORDER, CARD_BORDER, 0, CARD_BORDER)];
        [button addTarget:self action:@selector(cardSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:image forState:UIControlStateNormal];
        
        // Add the button to our array of buttons
        [buttons addObject:button];
    }

    CGFloat contentSizeWidth = width * cardCount + CARD_PADDING * cardCount;
    UIView *subviewWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSizeWidth, height)];
    for (UIButton *b in buttons) {
        [subviewWrapper addSubview:b];
    }

    [self.cardHand addSubview:subviewWrapper];

    // Update our property with the button array
    self.cardButtons = [buttons copy];
    
    // Set the scrollview's content size, so that it scrolls
    self.cardHand.contentSize = CGSizeMake(contentSizeWidth, height);
    
    [self updatePlayableCards];
    
    // Set that we need to redisplay the scrollview
    [self.cardHand setNeedsDisplay];
}

- (void)updatePlayableCards
{
    if (self.playerController.hand.count != self.cardButtons.count) {
        [self reloadData];
        return;
    }

    for (int i = 0; i < self.playerController.hand.count; i++) {
        BOOL disabled = NO;
        
        if (self.playerController.isTurn) {
            Card *c = [self.playerController.hand objectAtIndex:i];
            disabled = ![self.playerController canPlay:c];
        }

        UIButton *button = [self.cardButtons objectAtIndex:i];
        button.enabled = !disabled;
    }
    [self.buttonLayout setNeedsDisplay];
}

@end
