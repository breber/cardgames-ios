//
//  Server.h
//  CardGames
//
//  Created by Brian Reber on 9/9/12.
//  Copyright (c) 2012 Brian Reber. All rights reserved.
//
#import <netinet/in.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <arpa/inet.h>

#import "Server.h"
#import "WifiConnection.h"

// Declare some private properties and methods
@interface Server ()

@property (nonatomic) CFSocketRef socket;
@property (nonatomic) uint32_t protocolFamily;
@property (nonatomic) int port;
@property (nonatomic) NSNetService *netService;

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
    
    self.socket = CFSocketCreate(kCFAllocatorDefault,
                                 PF_INET6,
                                 SOCK_STREAM,
                                 IPPROTO_TCP,
                                 kCFSocketAcceptCallBack,
                                 (CFSocketCallBack)&TCPServerAcceptCallBack,
                                 &socketCtxt);
	
	if (self.socket)	{ // the socket was created successfully
		self.protocolFamily = PF_INET6;
	} else { // there was an error creating the IPv6 socket - could be running under iOS 3.x
		self.socket = CFSocketCreate(kCFAllocatorDefault,
                                     PF_INET,
                                     SOCK_STREAM,
                                     IPPROTO_TCP,
                                     kCFSocketAcceptCallBack,
                                     (CFSocketCallBack)&TCPServerAcceptCallBack,
                                     &socketCtxt);
		if (self.socket) {
			self.protocolFamily = PF_INET;
		}
	}
    
    if (NULL == self.socket) {
        return NO;
    }
	
	
    int yes = 1;
    setsockopt(CFSocketGetNative(self.socket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
	
	// set up the IP endpoint; use port 0, so the kernel will choose an arbitrary port for us, which will be advertised using Bonjour
	if (self.protocolFamily == PF_INET6) {
		struct sockaddr_in6 addr6;
		memset(&addr6, 0, sizeof(addr6));
		addr6.sin6_len = sizeof(addr6);
		addr6.sin6_family = AF_INET6;
		addr6.sin6_port = 0;
		addr6.sin6_flowinfo = 0;
		addr6.sin6_addr = in6addr_any;
		NSData *address6 = [NSData dataWithBytes:&addr6 length:sizeof(addr6)];
		
		if (kCFSocketSuccess != CFSocketSetAddress(self.socket, (__bridge CFDataRef)address6)) {
			self.socket = NULL;
			return NO;
		}
		
		// now that the binding was successful, we get the port number
		// -- we will need it for the NSNetService
		NSData *addr = (__bridge NSData *)CFSocketCopyAddress(self.socket);
		memcpy(&addr6, [addr bytes], [addr length]);
		self.port = ntohs(addr6.sin6_port);
	} else {
		struct sockaddr_in addr4;
		memset(&addr4, 0, sizeof(addr4));
		addr4.sin_len = sizeof(addr4);
		addr4.sin_family = AF_INET;
		addr4.sin_port = 0;
		addr4.sin_addr.s_addr = htonl(INADDR_ANY);
		NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
		
		if (kCFSocketSuccess != CFSocketSetAddress(self.socket, (__bridge CFDataRef)address4)) {
			self.socket = NULL;
			return NO;
		}
		
		// now that the binding was successful, we get the port number
		// -- we will need it for the NSNetService
		NSData *addr = (__bridge NSData *)CFSocketCopyAddress(self.socket);
		memcpy(&addr4, [addr bytes], [addr length]);
		self.port = ntohs(addr4.sin_port);
	}
	
    // set up the run loop sources for the sockets
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self.socket, 0);
    CFRunLoopAddSource(cfrl, source, kCFRunLoopCommonModes);
    CFRelease(source);
	
    [self publishService];
    
    return YES;
}

- (void)stop {
    [self unpublishService];
    
	if (self.socket) {
		CFSocketInvalidate(self.socket);
		self.socket = NULL;
	}
}


#pragma mark Bonjour

- (BOOL)publishService
{
    // come up with a name for our service
    // TODO: this won't currently be unique
    NSString* serviceName = [NSString stringWithFormat:@"Card Games - %@", [[UIDevice currentDevice] name]];

    // create new instance of netService
    self.netService = [[NSNetService alloc] initWithDomain:@""
                                                      type:@"_cardgames._tcp."
                                                      name:serviceName
                                                      port:self.port];

    if (self.netService == nil) {
        return NO;
    }

    // Add service to current run loop
    [self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSRunLoopCommonModes];

    // NetService will let us know about what's happening via delegate methods
    [self.netService setDelegate:self];

    // Publish the service
    [self.netService publish];

    return YES;
}


- (void)unpublishService
{
    [self.netService stop];
    [self.netService removeFromRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSRunLoopCommonModes];
    self.netService = nil;
}

#pragma mark NSNetService Delegate Method Implementations

// Delegate method, called by NSNetService in case service publishing fails for whatever reason
- (void)netService:(NSNetService *)sender
     didNotPublish:(NSDictionary *)errorDict
{
    if (sender != self.netService) {
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
