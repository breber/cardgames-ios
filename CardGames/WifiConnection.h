//
//  WifiConnection.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionListener.h"

@interface WifiConnection : NSObject <NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
}

@property id <ConnectionListener> listener;

+ (id)sharedInstance;

- (BOOL)initWithNativeSocket:(CFSocketNativeHandle)socket;
- (BOOL)initNetworkCommunication:(NSNetService *)service;
- (void)closeConnections;
- (BOOL)isActive;
- (BOOL)write:(NSString *)data withType:(int)type;

@end
