//
//  WifiConnection.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "WifiConnection.h"
#import <CFNetwork/CFSocketStream.h>

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
                    withData:(int)data
{
    self.data = data;
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

- (BOOL)initNetworkCommunication:(NSNetService *)service
{
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

- (void)closeConnections
{
    [outputStream close];
    [inputStream close];
}

- (BOOL)isActive
{
    return (outputStream.streamStatus == NSStreamStatusOpen) &&
            (inputStream.streamStatus == NSStreamStatusOpen);
}

- (BOOL)writeDictionary:(NSDictionary *)dict
               withType:(int)type
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self write:str withType:type];
}

- (BOOL)write:(NSString *)data
     withType:(int)type
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: data, @"DATA", [NSString stringWithFormat:@"%i", type], @"MSG_TYPE", nil];
    NSData *dataToWrite = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    
    return [outputStream write:[dataToWrite bytes] maxLength:[dataToWrite length]] == [dataToWrite length];
}

- (void)stream:(NSStream *)aStream
   handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
		case NSStreamEventOpenCompleted:
            if (aStream == outputStream) {
                if ([self.listener respondsToSelector:@selector(outputStreamOpened)]) {
                    [self.listener outputStreamOpened:self];
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
                            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[output dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                            
                            if ([self.listener respondsToSelector:@selector(newDataArrived:withData:withType:)]) {
                                NSString *data = [jsonObject objectForKey:@"DATA"];
                                int type = [[jsonObject objectForKey:@"MSG_TYPE"] intValue];
                                
                                [self.listener newDataArrived:self withData:data withType:type];
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
                [self.listener outputStreamClosed:self];
            }
            break;
            
		default:
			NSLog(@"Unknown event %i", eventCode);
	}
}

@end
