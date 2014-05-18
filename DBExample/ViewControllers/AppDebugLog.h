//
//  AppDebugLog.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDebugLog : NSObject

+(void)writeDebugData:(NSString*)debugStr;
+(void)createLog;

@end
