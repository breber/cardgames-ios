//
//  PlayViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalTableView.h"
#import "PlayerController.h"
#import "ViewController.h"

@interface PlayViewController : ViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PlayerControllerDelegate> {
    IBOutlet UIView *buttonLayout;

    IBOutlet UIView *overlay;
    IBOutlet UITextField *textPopupTextField;
    IBOutlet UIView *textPopup;
    IBOutlet UIView *loadingPopup;
    IBOutlet UILabel *loadingPopupTitle;
}

@property(nonatomic, strong) IBOutlet HorizontalTableView *cardHand;
@property(nonatomic, strong) PlayerController *playerController;

@end
