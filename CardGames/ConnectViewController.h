//
//  ConnectViewController.h
//  CardGames
//
//  Created by Brian Reber on 9/15/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ViewController.h"

@interface ConnectViewController : ViewController {
    IBOutlet UILabel *deviceName;
    IBOutlet UIButton *startButton;
    
    IBOutlet UILabel *player1Name;
    IBOutlet UILabel *player2Name;
    IBOutlet UILabel *player3Name;
    IBOutlet UILabel *player4Name;
    
    IBOutlet UIActivityIndicatorView *player1Loading;
    IBOutlet UIActivityIndicatorView *player2Loading;
    IBOutlet UIActivityIndicatorView *player3Loading;
    IBOutlet UIActivityIndicatorView *player4Loading;
    
    IBOutlet UIView *player1Device;
    IBOutlet UIView *player2Device;
    IBOutlet UIView *player3Device;
    IBOutlet UIView *player4Device;
}

@end
