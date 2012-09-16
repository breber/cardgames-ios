//
//  WifiConnection.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "WifiConnection.h"
#import <CFNetwork/CFSocketStream.h>
#import "SBJson.h"

@implementation WifiConnection

static WifiConnection *instance = nil;

@synthesize listener = _listener;

+ (WifiConnection *)sharedInstance {
    if (instance == nil) {
        instance = [[WifiConnection alloc] init];
    }
    
    return instance;
}

- (BOOL)initWithNativeSocket:(CFSocketNativeHandle)socket {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, socket, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    return YES;
}

- (BOOL)initNetworkCommunication:(NSNetService *)service {
    NSInputStream *readStream;
    NSOutputStream *writeStream;
    
    if ([service getInputStream:&readStream outputStream:&writeStream]) {
        inputStream = readStream;
        outputStream = writeStream;
        
        [inputStream setDelegate:self];
        [outputStream setDelegate:self];
        
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [inputStream open];
        [outputStream open];
        return YES;
    }
    
    return NO;
}

- (void)closeConnections {
    [outputStream close];
    [inputStream close];
}

- (BOOL)isActive {
    return (outputStream.streamStatus == NSStreamStatusOpen) &&
            (inputStream.streamStatus == NSStreamStatusOpen);
}

- (BOOL)write:(NSString *)data withType:(int)type {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: data, @"DATA", [NSString stringWithFormat:@"%i", type], @"MSG_TYPE", nil];
    NSData *dataToWrite = [[dict JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
    
    return [outputStream write:[dataToWrite bytes] maxLength:[dataToWrite length]] == [dataToWrite length];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
		case NSStreamEventOpenCompleted:
            if (aStream == outputStream) {
                if ([self.listener respondsToSelector:@selector(outputStreamOpened)]) {
                    [self.listener outputStreamOpened];
                }
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
                            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
                            NSDictionary *jsonObject = [jsonParser objectWithString:output];
                            
                            if ([self.listener respondsToSelector:@selector(newDataArrived:withType:)]) {
                                NSString *data = [jsonObject objectForKey:@"DATA"];
                                int type = [[jsonObject objectForKey:@"MSG_TYPE"] intValue];
                                
                                [self.listener newDataArrived:data withType:type];
                            }
                        }
                    }
                }
            }
			break;
            
        case NSStreamEventHasSpaceAvailable:
            break;
            
		case NSStreamEventErrorOccurred:
        case NSStreamEventEndEncountered:
            [outputStream close];
            [inputStream close];
            
            if ([self.listener respondsToSelector:@selector(outputStreamClosed)]) {
                [self.listener outputStreamClosed];
            }
            break;
            
		default:
			NSLog(@"Unknown event %i", eventCode);
	}
}

@end
