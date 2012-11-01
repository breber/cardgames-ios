//
//  Server.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>

#import "Server.h"
#import "WifiConnection.h"

// Declare some private properties and methods
@interface Server ()
@property(nonatomic,assign) uint16_t port;
@property(nonatomic,retain) NSNetService* netService;

- (BOOL)createServer;
- (void)terminateServer;

- (BOOL)publishService;
- (void)unpublishService;
@end


// Implementation of the Server interface
@implementation Server

@synthesize delegate;
@synthesize port, netService;

// Create server and announce it
- (BOOL)start
{
    // Start the socket server
    if (![self createServer]) {
        return NO;
    }

    // Announce the server via Bonjour
    if (![self publishService]) {
        [self terminateServer];
        return NO;
    }

    return YES;
}


// Close everything
- (void)stop
{
    [self terminateServer];
    [self unpublishService];
}


#pragma mark Callbacks

// Handle new connections
- (void)handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle
{
    WifiConnection* connection = [WifiConnection sharedInstance];

    if (![connection initWithNativeSocket:nativeSocketHandle]) {
        NSLog(@"couldn't init");
    }

    // Pass this on to our delegate
    [delegate handleNewConnection:connection];
}


// This function will be used as a callback while creating our listening socket via 'CFSocketCreate'
static void serverAcceptCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    Server *server = (__bridge Server*)info;

    // We can only process "connection accepted" calls here
    if ( type != kCFSocketAcceptCallBack ) {
        return;
    }

    // for an AcceptCallBack, the data parameter is a pointer to a CFSocketNativeHandle
    CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle*)data;

    [server handleNewNativeSocket:nativeSocketHandle];
}


#pragma mark Sockets and streams

- (BOOL)createServer
{
    //// PART 1: Create a socket that can accept connections
    CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};

    listeningSocket = CFSocketCreate(
                                    kCFAllocatorDefault,
                                    PF_INET,        // The protocol family for the socket
                                    SOCK_STREAM,    // The socket type to create
                                    IPPROTO_TCP,    // The protocol for the socket. TCP vs UDP.
                                    kCFSocketAcceptCallBack,  // New connections will be automatically accepted and the callback is called with the data argument being a pointer to a CFSocketNativeHandle of the child socket.
                                    (CFSocketCallBack)&serverAcceptCallback,
                                    &socketCtxt
                                    );

    // Previous call might have failed
    if (listeningSocket == NULL) {
        return NO;
    }

    // getsockopt will return existing socket option value via this variable
    int existingValue = 1;

    // Make sure that same listening socket address gets reused after every connection
    setsockopt(CFSocketGetNative(listeningSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&existingValue, sizeof(existingValue));


    //// PART 2: Bind our socket to an endpoint.
    // We will be listening on all available interfaces/addresses.
    // Port will be assigned automatically by kernel.
    struct sockaddr_in socketAddress;
    memset(&socketAddress, 0, sizeof(socketAddress));
    socketAddress.sin_len = sizeof(socketAddress);
    socketAddress.sin_family = AF_INET;   // Address family (IPv4 vs IPv6)
    socketAddress.sin_port = 1234;           // Actual port will get assigned automatically by kernel
    socketAddress.sin_addr.s_addr = htonl(INADDR_ANY);    // We must use "network byte order" format (big-endian) for the value here

    // Convert the endpoint data structure into something that CFSocket can use
    NSData *socketAddressData = [NSData dataWithBytes:&socketAddress length:sizeof(socketAddress)];

    // Bind our socket to the endpoint. Check if successful.
    if (CFSocketSetAddress(listeningSocket, (__bridge CFDataRef)socketAddressData) != kCFSocketSuccess) {
        // Cleanup
        if (listeningSocket != NULL) {
            CFRelease(listeningSocket);
            listeningSocket = NULL;
        }

        return NO;
    }


    //// PART 3: Find out what port kernel assigned to our socket
    // We need it to advertise our service via Bonjour
    NSData *socketAddressActualData = (__bridge NSData *)CFSocketCopyAddress(listeningSocket);

    // Convert socket data into a usable structure
    struct sockaddr_in socketAddressActual;
    memcpy(&socketAddressActual, [socketAddressActualData bytes], [socketAddressActualData length]);
      
    self.port = ntohs(socketAddressActual.sin_port);

    //// PART 4: Hook up our socket to the current run loop
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef runLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, listeningSocket, 0);
    CFRunLoopAddSource(currentRunLoop, runLoopSource, kCFRunLoopCommonModes);
    CFRelease(runLoopSource);

    return YES;
}


- (void)terminateServer
{
    if (listeningSocket) {
        CFSocketInvalidate(listeningSocket);
        CFRelease(listeningSocket);
        listeningSocket = nil;
    }
}


#pragma mark Bonjour

- (BOOL)publishService
{
    // come up with a name for our service
    // TODO: this won't currently be unique
    NSString* serviceName = [NSString stringWithFormat:@"Card Games - %@", [[UIDevice currentDevice] name]];

    // create new instance of netService
    self.netService = [[NSNetService alloc] initWithDomain:@"" type:@"_cardgames._tcp." name:serviceName port:self.port];

    if (self.netService == nil) {
        return NO;
    }

    // Add service to current run loop
    [self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    // NetService will let us know about what's happening via delegate methods
    [self.netService setDelegate:self];

    // Publish the service
    [self.netService publish];

    return YES;
}


- (void)unpublishService
{
    if (self.netService) {
        [self.netService stop];
        [self.netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.netService = nil;
    }
}

#pragma mark NSNetService Delegate Method Implementations

// Delegate method, called by NSNetService in case service publishing fails for whatever reason
- (void)netService:(NSNetService*)sender
     didNotPublish:(NSDictionary*)errorDict
{
    if (sender != self.netService) {
        return;
    }

    // Stop socket server
    [self terminateServer];

    // Stop Bonjour
    [self unpublishService];

    // Let delegate know about failure
    [delegate serverFailed:self reason:@"Failed to publish service via Bonjour (duplicate server name?)"];
}

@end
