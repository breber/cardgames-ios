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

@property (nonatomic) int data;
@property (nonatomic, weak) id <ConnectionListener> delegate;

+ (id)sharedInstance;

- (BOOL)initWithNativeSocket:(CFSocketNativeHandle)socket
                    withData:(int)data;
- (BOOL)initNetworkCommunication:(NSNetService *)service;
- (void)closeConnections;
- (BOOL)isActive;
- (BOOL)writeDictionary:(NSDictionary *)dict withType:(int)type;
- (BOOL)write:(NSString *)data withType:(int)type;

@end
