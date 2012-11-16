//
//  WifiConnection.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "ConnectionDelegate.h"

@interface WifiConnection : NSObject

@property (nonatomic, strong) NSString *connectionId;
@property (nonatomic, weak) id <ConnectionDelegate> delegate;

+ (id)sharedInstance;

- (BOOL)initWithNativeSocket:(CFSocketNativeHandle)socket
                    withData:(NSString *)data;
- (BOOL)initNetworkCommunication:(NSNetService *)service;
- (void)closeConnections;
- (BOOL)isActive;
- (BOOL)writeDictionary:(NSDictionary *)dict withType:(int)type;
- (BOOL)write:(NSString *)data withType:(int)type;

@end
