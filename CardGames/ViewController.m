//
//  ViewController.m
//  CardGames
//
//  Created by Brian Reber on 8/31/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ViewController.h"
#import <iAd/iAd.h>

@implementation ViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft) &&
           (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
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

#pragma mark - iAd Stuff

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [banner setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [banner setHidden:YES];
}

@end
