//
//  AppDebugLog.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : writes out a Debug log for catching events.
//  Overwrites it once it get's to 10M in size so it doesn't get too large.
//

#import "AppDebugLog.h"
#import "AppDateFormatter.h"

@implementation AppDebugLog

static 	unsigned long long fileLength;

#define DEBUG_LOG_FILE @"AppDebug.log"
#define DEBUG_OLD_LOG_FILE @"AppDebug_old.log"
#define DEBUG_LOG_FILE_LENGTH 10000000

+(void)writeDebugData:(NSString*)debugStr
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *debugFileName = [documentsDirectory stringByAppendingPathComponent:DEBUG_LOG_FILE];
	NSString *debugFileNameOld = [documentsDirectory stringByAppendingPathComponent:DEBUG_OLD_LOG_FILE];
	NSFileHandle *aFileHandle = [NSFileHandle fileHandleForWritingAtPath:debugFileName];
    AppDateFormatter *dateFormatter = [[AppDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *debugStrLoc = [NSString stringWithFormat:@"%@ : %@ : %@ \n",[dateFormatter stringFromDate:[NSDate date]],[[NSThread currentThread] name], debugStr];
    
    if(aFileHandle == nil || fileLength > DEBUG_LOG_FILE_LENGTH) {
		NSError *error = nil;
		if(aFileHandle != nil) {
			NSFileManager *fileManager = [[NSFileManager alloc] init];
			[fileManager moveItemAtPath:debugFileName toPath:debugFileNameOld error:&error];
		}
		[debugStrLoc writeToFile:debugFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
	}
	
	if(aFileHandle != nil)
    {
        @synchronized(aFileHandle)
        {
            [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
            [aFileHandle writeData:[debugStrLoc dataUsingEncoding:NSUTF8StringEncoding]];
            fileLength = [aFileHandle offsetInFile];
            [aFileHandle synchronizeFile];
            [aFileHandle closeFile];
        }
    }
}

+(void)createLog
{
	NSLog(@"AppDebugLog : create AppDebugLog");
	fileLength = 0;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *settingsFileName = [documentsDirectory stringByAppendingPathComponent:DEBUG_LOG_FILE];
	NSError *error = nil;
	AppDateFormatter *dateFormatter = [[AppDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	NSString *debugStrLoc = [NSString stringWithFormat:@"Created : %@  \n",[dateFormatter stringFromDate:[NSDate date]]];
	[debugStrLoc writeToFile:settingsFileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

@end
