//
//  ConnectionListener.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionListener <NSObject>

@optional
- (void)outputStreamOpened;
- (void)outputStreamClosed;
- (void)newDataArrived:(NSString *)data withType:(int) type;

@end
