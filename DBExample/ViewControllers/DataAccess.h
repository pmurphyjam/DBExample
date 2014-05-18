//
//  DataAccess.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
#import <sqlite3.h>
#import "AppQueryParameter.h"

@interface DataAccess : NSObject
{
    sqlite3 *sqlite3dbConn;
    long lastInsertedIdentity;
    int conn_pointer;
}

-(BOOL)openConnection;
-(int)currentSizeOfDatabase;
-(NSMutableArray*)GetRecordsForQuery:(NSString*)query WithParameters:(NSMutableArray*)parameters;
-(NSMutableArray*)GetRecordsForQuery:(NSString*)query, ... NS_REQUIRES_NIL_TERMINATION;
-(BOOL)ExecuteTransaction:(NSMutableArray *)sqlAndParamsForTransaction;
-(BOOL)ExecuteStatement:(NSString*)query WithParameters:(NSMutableArray*) parameters;
-(BOOL)ExecuteStatement:(NSString*)query, ... NS_REQUIRES_NIL_TERMINATION;
-(BOOL)ExecuteStatement:(NSString*)query WithParameters:(NSMutableArray*) parameters OutParameter:(NSString**)errorCodeStr;
-(void)closeConnection;
-(void)killDB;
-(NSString*)getDatabaseTables;
-(NSString*)getDatabaseDump;

@end