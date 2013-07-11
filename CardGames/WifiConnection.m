//
//  WifiConnection.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "WifiConnection.h"
#import <CFNetwork/CFSocketStream.h>

@interface WifiConnection() <NSStreamDelegate>

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation WifiConnection

static WifiConnection *instance = nil;

+ (WifiConnection *)sharedInstance
{
    if (instance == nil) {
        instance = [[WifiConnection alloc] init];
    }
    
    return instance;
}

- (BOOL)initWithNativeSocket:(CFSocketNativeHandle)socket
                    withData:(NSString *)data
{
    self.connectionId = data;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, socket, &readStream, &writeStream);
    self.inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    self.outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];

    return YES;
}

- (BOOL)initNetworkCommunication:(NSNetService *)service
{
    if (self.inputStream || self.outputStream) {
        return NO;
    }

    NSInputStream *readStream;
    NSOutputStream *writeStream;
    
    if ([service getInputStream:&readStream outputStream:&writeStream]) {
        self.inputStream = readStream;
        self.outputStream = writeStream;
        
        [self.inputStream setDelegate:self];
        [self.outputStream setDelegate:self];
        
        [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.inputStream open];
        [self.outputStream open];

        return YES;
    }
    
    return NO;
}

- (void)closeConnections
{
#if DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
    [self.outputStream close];
    [self.inputStream close];

    self.outputStream = nil;
    self.inputStream = nil;
}

- (BOOL)isActive
{
    return (self.outputStream.streamStatus == NSStreamStatusOpen) &&
            (self.inputStream.streamStatus == NSStreamStatusOpen);
}

- (BOOL)writeDictionary:(NSDictionary *)dict
               withType:(int)type
{
#if DEBUG
    if (LOG_CONNECTION_WRITE) {
        NSLog(@"%s (%d): %@", __PRETTY_FUNCTION__, type, dict);
    }
#endif
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self write:str withType:type];
}

- (BOOL)write:(NSString *)data
     withType:(int)type
{
    if (!data) {
        return NO;
    }

#if DEBUG
    if (LOG_CONNECTION_WRITE) {
        NSLog(@"%s (%d): %@", __PRETTY_FUNCTION__, type, data);
    }
#endif

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: data, @"DATA", [NSString stringWithFormat:@"%i", type], @"MSG_TYPE", nil];
    NSData *dataToWrite = [NSJSONSerialization dataWithJSONObject:dict
                                                          options:kNilOptions
                                                            error:nil];
    
    return [self.outputStream write:[dataToWrite bytes]
                          maxLength:[dataToWrite length]] == [dataToWrite length];
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream
   handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
		case NSStreamEventOpenCompleted:
            if (aStream == self.outputStream) {
#if DEBUG
                NSLog(@"%s NSEventOpenCompleted", __PRETTY_FUNCTION__);
#endif
                if ([self.delegate respondsToSelector:@selector(outputStreamOpened:)]) {
                    [self.delegate outputStreamOpened:self];
                }
            }
            break;
            
		case NSStreamEventHasBytesAvailable:
            if (aStream == self.inputStream) {
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (output) {
                            // TODO: multiple json objects mashed together
                            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[output dataUsingEncoding:NSUTF8StringEncoding]
                                                                                       options:0
                                                                                         error:nil];

#if DEBUG
                            if (LOG_CONNECTION_READ) {
                                NSLog(@"%s - READ: %@", __PRETTY_FUNCTION__, output);
                            }
#endif

                            if (jsonObject && [self.delegate respondsToSelector:@selector(newDataArrived:withData:withType:)]) {
                                NSString *data = [jsonObject objectForKey:@"DATA"];
                                int type = [[jsonObject objectForKey:@"MSG_TYPE"] intValue];
                                
                                [self.delegate newDataArrived:self withData:data withType:type];
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
#if DEBUG
            NSLog(@"%s NSStreamEventErrorOccurred || NSStreamEventEndEncountered", __PRETTY_FUNCTION__);
#endif
            [self.outputStream close];
            [self.inputStream close];
            
            if ([self.delegate respondsToSelector:@selector(outputStreamClosed:)]) {
                [self.delegate outputStreamClosed:self];
            }
            break;
            
		default:
			NSLog(@"Unknown event %i", eventCode);
	}
}

@end
