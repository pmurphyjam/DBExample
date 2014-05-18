//
//  AppConnectionOperation.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : An NSOperationQueue with an NSURLConnection.
//  Used in place of NSURLSession which is only good for iOS7
//  Developer can append a messageID, messageArray, or messageDic with the
//  connection which can be used to update messageID's from old to new server values.
//
#import "AppConnectionOperation.h"
#import "SettingsModel.h"
#import "AppDebugLog.h"
#import "NSData+Category.h"

@implementation AppConnectionOperation

@synthesize error;
@synthesize connectionURL;
@synthesize connection;
@synthesize connectionName;
@synthesize loginName;
@synthesize loginPassword;
@synthesize messageID;
@synthesize errorMessage;
@synthesize messageDic;
@synthesize messageArray;
@synthesize statusCode;
@synthesize data;
@synthesize request;
@synthesize status;
@synthesize executing;
@synthesize finished;
@synthesize executeRunLoop;
@synthesize messagesToDelete;

//#define DEBUG
#import "AppConstants.h"

#pragma mark Initialization

- (id)initWithRequest:(NSMutableURLRequest *)theRequest forConnection:(NSString*)connectionNameInst
{
    if( (self = [super init]) ) {
		[self setRequest:theRequest];
		[self setConnectionName:connectionNameInst];
    }
	
    return self;
}

- (id)initWithURL:(NSURL *)url forConnection:(NSString*)connectionNameInst
{
    if( (self = [super init]) )
    {
        [self setConnectionName:connectionNameInst];
        [self setRequest:[NSMutableURLRequest requestWithURL:url]];
        [self setConnectionURL:url];
    }
    
    return self;
}

#pragma mark Start & NSOperation Methods

- (void)done
{
    if (!self)
    {
        return;
    }
    NDLog(@"AppConnection : done : connectionName = %@",connectionName);
    if(executing)
    {
        [self willChangeValueForKey:@"isExecuting"];
        executing = NO;
        [self didChangeValueForKey:@"isExecuting"];
    }
    if(!finished)
    {
        [self willChangeValueForKey:@"isFinished"];
        finished  = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    if( connection != nil)
    {
        [connection cancel];
        connection = nil;
        NDLog(@"AppConnection : done : connection cancel : connectionName = %@",connectionName);
    }
}

-(void)canceled
{
    NDLog(@"AppConnection : canceled : connectionName = %@",connectionName);
    error = [[NSError alloc] initWithDomain:@"DownloadUrlOperation"
                                       code:123
                                   userInfo:nil];
    if(executing && !finished)
        [self done];
}

//
- (void)start
{
    if([self isCancelled] ) { [self done]; return; }
    if(!executeRunLoop)
    {
        //This method needs to execute on the mainThread, if not call it again on the mainThread
        if (![[NSThread currentThread] isEqual:[NSThread mainThread]] )
        {
            [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
            return;
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        statusCode = 0;
        status = FALSE;
        errorMessage = @"";
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        NDLog(@"AppConnection : connectionName = %@ : request = %@",connectionName,request);
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [connection start];
    }
    else
    {
        //In case you want a runLoop and run on a back ground thread
        NDLog(@"AppConnection : connectionName = %@ : executeRunLoop = %@ : request = %@",connectionName,executeRunLoop?@"YES":@"NO",request);
        //This defers a connection to a background thread run Loop by setting startImmediately:NO
        [request setTimeoutInterval:300];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self didChangeValueForKey:@"isExecuting"];
        statusCode = 0;
        status = FALSE;
        errorMessage = @"";
        NSPort* port = [NSPort port];
        NSRunLoop* rl = [NSRunLoop currentRunLoop];
        [rl addPort:port forMode:NSDefaultRunLoopMode];
        [connection scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
        [connection start];
        [rl run];
    }
}

#pragma mark NSOperation Overrides

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}

- (BOOL)isFinished
{
    return finished;
}

- (BOOL)dependency
{
    if([self.dependencies count] > 0)
        return YES;
    else
        return NO;
}

#pragma mark Delegate Methods for NSURLConnection

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)inError
{
    NDLog(@"AppConnection : didFailWithError");
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
	else
    {
		data = nil;
		error = inError;
		[self done];
	}
}

#pragma mark AppConnection Authentication Challenge

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NDLog(@"AppConnection : didReceiveAuthenticationChallenge : Connection = %@",connectionName);
	NDLog(@"AppConnection : %@" , [[challenge protectionSpace] authenticationMethod]);
	if ([challenge previousFailureCount] > 0)
	{
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		NDLog(@"CardsService : Auth Request Failed Challenge, Bad User Name or Password");
		status = FALSE;
	}
    else if ([challenge.protectionSpace.authenticationMethod
              isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		// we only trust our own domain
		if ([challenge.protectionSpace.host isEqualToString:ServerUrl])
		{
            NDLog(@"AppConnection : Auth Request Self signed Cert");
			NSURLCredential *credential =
            [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        }
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
	}
	else
	{
		NDLog(@"AppConnection : Using username password credentials %@ ", loginName);
		NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:(NSString*)loginName password:(NSString*)loginPassword
                                              persistence:NSURLCredentialPersistenceNone];
		
        [[challenge sender] useCredential:newCredential
			   forAuthenticationChallenge:challenge];
	}
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	//Need this to authenticate
	return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData
{
    NDLog(@"AppConnection : didReceiveData isCancelled = %@ : isFinished = %@ : Connection = %@",self.isCancelled?@"YES":@"NO",self.isFinished?@"YES":@"NO",connectionName);
    // Check if the operation has been cancelled
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
    [data appendData:inData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NDLog(@"AppConnection : didReceiveResponse isCancelled = %@ : isFinished = %@ : Connection = %@",self.isCancelled?@"YES":@"NO",self.isFinished?@"YES":@"NO",connectionName);
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    statusCode = [httpResponse statusCode];
    if( statusCode == 200 )
    {
        NDLog(@"AppConnection : didReceiveResponse : Connection = %@",connectionName);
        NSUInteger contentSize = [httpResponse expectedContentLength] > 0 ? [httpResponse expectedContentLength] : 0;
		data = [[NSMutableData alloc] initWithCapacity:contentSize];
    }
    else
    {
        NSString* statusError  = [NSString stringWithFormat:NSLocalizedString(@"HTTP Error: %ld", nil), statusCode];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:statusError forKey:NSLocalizedDescriptionKey];
        error = [[NSError alloc] initWithDomain:@"DownloadUrlOperation"
                                           code:statusCode
                                       userInfo:userInfo];
        status = NO;
        [self done];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NDLog(@"AppConnection : connectionDidFinishLoading isCancelled = %@ : isFinished = %@ : Connection = %@",self.isCancelled?@"YES":@"NO",self.isFinished?@"YES":@"NO",connectionName);
    
    
    if([self isCancelled])
    {
        [self canceled];
		return;
    }
	else
    {
        if([data length] > 0 && statusCode == 200 )
        {
            if([data length] < 300)
            {
                //Possible Error message need to check
                NSError *err;
                id jsonID = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:kNilOptions
                             error:&err];
                
                NSDictionary *json = nil;
                
                if ([jsonID isKindOfClass:[NSArray class]])
                {
                    NDLog(@"AppConnection : Got a small JSON ARRAY = %@",(NSArray*)jsonID);
                }
                
                if ([jsonID isKindOfClass:[NSDictionary class]])
                    json = (NSDictionary*)jsonID;
                
                if ([json count] > 0)
                {
                    NSDictionary *errorCodeFromServerDic = [json objectForKey:@"error"];
                    if([errorCodeFromServerDic count] == 2)
                    {
                        NSString *errorCode = [errorCodeFromServerDic objectForKey:@"code"];
                        NSString *errorMessageInst = [errorCodeFromServerDic objectForKey:@"message"];
                        errorMessage = [NSString stringWithFormat:@"%@", errorMessageInst];
                        NSLog(@"AppConnection : DidFinish : ERROR : ErrorCode = %@ : Message = %@ : Connection = %@",errorCode,errorMessageInst,connectionName);
                        status = NO;
                    }
                    else
                        status = YES;
                }
                else
                    status = YES;
            }
            else
                status = YES;
        }
        else if ([data length] == 0)
        {
            status = NO;
            NSLog(@"AppConnection : DidFinish : ERROR : NO DATA RETURNED : Connection = %@",connectionName);
            errorMessage = [NSString stringWithFormat:@"ERROR : NO DATA RETURNED : Connection = %@",connectionName];
            errorMessage = NSLocalizedString(@"alert_message_no_data", @"No Data");
        }
        else if( statusCode != 200 )
        {
            status = NO;
            NSLog(@"AppConnection : DidFinish : ERROR : BAD STATUS != 200 CODE = %d : Connection = %@",statusCode,connectionName);
            errorMessage = NSLocalizedString(@"alert_message_not_successful", @"Not Successful");
        }
        [self done];
	}
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

@end
