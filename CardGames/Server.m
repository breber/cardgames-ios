//
//  Server.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//
#import <netinet/in.h>
#import <sys/socket.h>

#include <sys/types.h>
#include <arpa/inet.h>

#import "Server.h"
#import "WifiConnection.h"

// Declare some private properties and methods
@interface Server () {
    CFSocketRef socket;
    uint32_t protocolFamily;
    int port;
}

- (BOOL)publishService;
- (void)unpublishService;
@end


// Implementation of the Server interface
@implementation Server

// This function is called by CFSocket when a new connection comes in.
// We gather some data here, and convert the function call to a method
// invocation on TCPServer.
static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    Server *server = (__bridge Server *)info;
    if (kCFSocketAcceptCallBack == type) {
        // for an AcceptCallBack, the data parameter is a pointer to a CFSocketNativeHandle
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        struct sockaddr_in peer;
        socklen_t peer_len = sizeof(peer);

        if (0 != getpeername(nativeSocketHandle, (struct sockaddr *)&peer, &peer_len)) {
            NSLog(@"Error getting peer name...");
        }

        NSLog(@"Peer's IP address is: %s\n", inet_ntoa(peer.sin_addr));
        NSLog(@"Peer's port is: %d\n", (int) ntohs(peer.sin_port));
        
        // TODO:
        WifiConnection* connection = [[WifiConnection alloc] init];
        
        if (![connection initWithNativeSocket:nativeSocketHandle withData:ntohs(peer.sin_port)]) {
            NSLog(@"couldn't init");
        }
        
        [server.delegate handleNewConnection:connection];
    }
}

- (BOOL)start
{
    CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
	// Start by trying to do everything with IPv6.  This will work for both IPv4 and IPv6 clients
    // via the miracle of mapped IPv4 addresses.
    
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET6, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack, &socketCtxt);
	
	if (socket != NULL)	{ // the socket was created successfully
		protocolFamily = PF_INET6;
	} else { // there was an error creating the IPv6 socket - could be running under iOS 3.x
		socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack, &socketCtxt);
		if (socket != NULL) {
			protocolFamily = PF_INET;
		}
	}
    
    if (NULL == socket) {
        if (socket) CFRelease(socket);
        socket = NULL;
        return NO;
    }
	
	
    int yes = 1;
    setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
	
	// set up the IP endpoint; use port 0, so the kernel will choose an arbitrary port for us, which will be advertised using Bonjour
	if (protocolFamily == PF_INET6) {
		struct sockaddr_in6 addr6;
		memset(&addr6, 0, sizeof(addr6));
		addr6.sin6_len = sizeof(addr6);
		addr6.sin6_family = AF_INET6;
		addr6.sin6_port = 0;
		addr6.sin6_flowinfo = 0;
		addr6.sin6_addr = in6addr_any;
		NSData *address6 = [NSData dataWithBytes:&addr6 length:sizeof(addr6)];
		
		if (kCFSocketSuccess != CFSocketSetAddress(socket, (__bridge CFDataRef)address6)) {
			if (socket) CFRelease(socket);
			socket = NULL;
			return NO;
		}
		
		// now that the binding was successful, we get the port number
		// -- we will need it for the NSNetService
		NSData *addr = (__bridge NSData *)CFSocketCopyAddress(socket);
		memcpy(&addr6, [addr bytes], [addr length]);
		port = ntohs(addr6.sin6_port);
	} else {
		struct sockaddr_in addr4;
		memset(&addr4, 0, sizeof(addr4));
		addr4.sin_len = sizeof(addr4);
		addr4.sin_family = AF_INET;
		addr4.sin_port = 0;
		addr4.sin_addr.s_addr = htonl(INADDR_ANY);
		NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
		
		if (kCFSocketSuccess != CFSocketSetAddress(socket, (__bridge CFDataRef)address4)) {
			if (socket) CFRelease(socket);
			socket = NULL;
			return NO;
		}
		
		// now that the binding was successful, we get the port number
		// -- we will need it for the NSNetService
		NSData *addr = (__bridge NSData *)CFSocketCopyAddress(socket);
		memcpy(&addr4, [addr bytes], [addr length]);
		port = ntohs(addr4.sin_port);
	}
	
    // set up the run loop sources for the sockets
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(cfrl, source, kCFRunLoopCommonModes);
    CFRelease(source);
	
    [self publishService];
    
    return YES;
}

- (void)stop {
    [self unpublishService];
    
	if (socket) {
		CFSocketInvalidate(socket);
		CFRelease(socket);
		socket = NULL;
	}
}


#pragma mark Bonjour

- (BOOL)publishService
{
    // come up with a name for our service
    // TODO: this won't currently be unique
    NSString* serviceName = [NSString stringWithFormat:@"Card Games - %@", [[UIDevice currentDevice] name]];

    // create new instance of netService
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_cardgames._tcp." name:serviceName port:port];

    if (netService == nil) {
        return NO;
    }

    // Add service to current run loop
    [netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    // NetService will let us know about what's happening via delegate methods
    [netService setDelegate:self];

    // Publish the service
    [netService publish];

    return YES;
}


- (void)unpublishService
{
    if (netService) {
        [netService stop];
        [netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        netService = nil;
    }
}

#pragma mark NSNetService Delegate Method Implementations

// Delegate method, called by NSNetService in case service publishing fails for whatever reason
- (void)netService:(NSNetService*)sender
     didNotPublish:(NSDictionary*)errorDict
{
    if (sender != netService) {
        return;
    }

    // Stop socket server
    [self stop];

    // Stop Bonjour
    [self unpublishService];

    // Let delegate know about failure
    [self.delegate serverFailed:self reason:@"Failed to publish service via Bonjour (duplicate server name?)"];
}

@end
