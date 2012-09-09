//
//  PlayViewController.m
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () {
    BOOL sendName;
}
@end

@implementation PlayViewController

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
    
    sendName = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter IP Address" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *result = [textField text];
    
    if ([[alertView title] isEqualToString:@"Enter IP Address"]) {
        [self initNetworkCommunication:result];
    } else if ([[alertView title] isEqualToString:@"Enter Name"]) {
        NSString *toWrite = [NSString stringWithFormat:@"{\"DATA\":\"{\\\"playername\\\":\\\"%@\\\"}\",\"MSG_TYPE\":1915416160}", result];
        NSData *data = [toWrite dataUsingEncoding:NSUTF8StringEncoding];
        
        [outputStream write:[data bytes] maxLength:[data length]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // TODO: should the connections be closed here?
    [outputStream close];
    [inputStream close];
}

- (void) outputStreamOpened {
    // Show a popup requesting the IP address of the server to connect to
    UIAlertView *temp = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    temp.alertViewStyle = UIAlertViewStylePlainTextInput;
    [temp show];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
		case NSStreamEventOpenCompleted:
            if (aStream == inputStream) {
                NSLog(@"Input: stream opened");
            } else if (aStream == outputStream) {
                NSLog(@"Output: stream opened");
                [self outputStreamOpened];
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
