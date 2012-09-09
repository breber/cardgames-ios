//
//  WifiConnection.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "WifiConnection.h"

@implementation WifiConnection

static WifiConnection *instance = nil;

@synthesize listener = _listener;

+ (WifiConnection *)sharedInstance {
    if (instance == nil) {
        instance = [[WifiConnection alloc] init];
    }
    
    return instance;
}

- (void)initNetworkCommunication:(NSString *)address {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)CFBridgingRetain(address), 1234, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
}

- (void)closeConnections {
    [outputStream close];
    [inputStream close];
}

- (BOOL) write:(NSString *)data {
    NSData *dataToWrite = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    return [outputStream write:[dataToWrite bytes] maxLength:[dataToWrite length]] == [dataToWrite length];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
		case NSStreamEventOpenCompleted:
            if (aStream == inputStream) {
                NSLog(@"Input: stream opened");
            } else if (aStream == outputStream) {
                NSLog(@"Output: stream opened");
                if ([self.listener respondsToSelector:@selector(outputStreamOpened)]) {
                    [self.listener outputStreamOpened];
                }
            } else {
                NSLog(@"Unknown: stream opened");
            }
            break;
            
		case NSStreamEventHasBytesAvailable:
            if (aStream == inputStream) {
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            // TODO:
                            if ([self.listener respondsToSelector:@selector(newDataArrived:withType:)]) {
                                [self.listener newDataArrived:output withType:0];
                            }
                        }
                    }
                }
            }
			break;
            
        case NSStreamEventHasSpaceAvailable:
            if (aStream == inputStream) {
                NSLog(@"Input: Has space available...");
            } else if (aStream == outputStream) {
                NSLog(@"Output: Has space available...");
            } else {
                NSLog(@"Unknown: Has space available...");
            }
            break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			NSLog(@"Stream end encountered!");
			break;
            
		default:
			NSLog(@"Unknown event %i", eventCode);
	}
}

@end
