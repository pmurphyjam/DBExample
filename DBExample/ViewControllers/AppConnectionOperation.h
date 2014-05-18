//
//  AppConnectionOperation.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AppConnectionOperation : NSOperation

{
    NSURL				*connectionURL;
    NSURLConnection		*connection;
    NSMutableData		*data;
    NSMutableURLRequest *request;
    NSString            *connectionName;
    NSString			*loginName;
	NSString			*loginPassword;
    NSString			*messageID;
    NSDictionary        *messageDic;
    BOOL                status;
    BOOL				executing;
    BOOL				finished;
}

@property (nonatomic, readonly) NSError* error;
@property (nonatomic, readonly) NSMutableData *data;
@property (nonatomic, strong) NSURL *connectionURL;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSString *connectionName;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *loginPassword;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSDictionary *messageDic;
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (nonatomic, strong) NSMutableArray *messagesToDelete;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) BOOL executing;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL executeRunLoop;
@property (atomic, readonly) NSURLConnection *connection;

- (id)initWithURL:(NSURL *)url forConnection:(NSString*)connectionNameInst;
- (id)initWithRequest:(NSMutableURLRequest *)theRequest forConnection:(NSString*)connectionNameInst;
- (BOOL)dependency;

@end
