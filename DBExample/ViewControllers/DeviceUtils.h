//
//  DeviceUtils.h
//  DBExample
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtils : NSObject

+(BOOL)isDeviceEncrypted;
+(NSString*)rawMacAddress;
+(NSString*)hashedMAC:(BOOL)uppercase colons:(BOOL)colons;
+(NSString*)hashedValue:(NSString *)value uppercase:(BOOL)uppercase;
+(NSString*)encryptedMAC;
+(NSString*)getURL:(NSString *)method;
+(NSString*)getPostHash: (NSString *)params;
+(NSMutableDictionary*)getPostHashParams: (NSMutableDictionary*) params;
+(NSString*)getPostHashAfterhHash: (NSString *)params;
+(NSString*)getArk;
+(NSString*)getArkOrIDFA;
+(NSString*)get_log_i;
+(NSString*)getSessionId;
+(BOOL)isNetworkAvailable;

@end
