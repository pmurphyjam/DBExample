//
//  SettingsModel.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Centralized Settings for the App, stored in a plist.
//

#import "SettingsModel.h"
#import "AppManager.h"
#import "AppDebugLog.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDateFormatter.h"

@implementation SettingsModel

__strong static NSUserDefaults *prefs;
__strong static NSDictionary *brandDic;

+(void)logout
{
    [self resetDefaults];
}

+ (void)resetDefaults
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+(void)setAccountID:(NSString*)accountID
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:accountID forKey:@"AccountID"];
}

+(NSString*)getAccountID
{
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:@"AccountID"];
}

+(void)setFirstName:(NSString*)firstName
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:firstName forKey:@"FirstName"];
}

+(NSString*)getFirstName
{
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:@"FirstName"];
}

+(void)setUserName:(NSString*)userName{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:userName forKey:@"UserName"];
}

+(NSString*)getUserName
{
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:@"UserName"];
}

+(void)setLastName:(NSString*)lastName
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:lastName forKey:@"LastName"];
}

+(void)setEmailAddress:(NSString*)emailAddress
{
    prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:emailAddress forKey:@"EmailAddress"];
}

+(NSString*)getEmailAddress
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *emailAddress = [prefs objectForKey:@"EmailAddress"];
    return emailAddress;
}

+(NSString*)getLastName
{
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:@"LastName"];
}

+(void)setPW0:(NSString*)someStr
{
    prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[AppManager AES256Encrypt:someStr] forKey:@"SOMESTR0"];
}

+(NSString*)getPW0
{
    [[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [AppManager AES256Decrypt:[prefs objectForKey:@"SOMESTR0"]];
}

+(void)setPW1:(NSString*)someStr
{
    prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[AppManager AES256Encrypt:someStr] forKey:@"SOMESTR1"];
}

+(NSString*)getPW1
{
    [[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [AppManager AES256Decrypt:[prefs objectForKey:@"SOMESTR1"]];
}

+(void)setDS0:(NSString*)someStr
{
    prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[AppManager AES256Encrypt:someStr] forKey:@"DSSTR0"];
}

+(NSString*)getDS0
{
    [[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [AppManager AES256Decrypt:[prefs objectForKey:@"DSSTR0"]];
}

+(void)setDS1:(NSString*)someStr
{
    prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:[AppManager AES256Encrypt:someStr] forKey:@"DSSTR1"];
}

+(NSString*)getDS1
{
    [[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [AppManager AES256Decrypt:[prefs objectForKey:@"DSSTR1"]];
}

+(void)setGotNewOne:(BOOL)gotNewOne
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:gotNewOne forKey:@"GotNewOne"];
}

+(BOOL)getGotNewOne
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"GotNewOne"];
}

+(void)setIsDBEncrypted:(BOOL)dbEncrpted
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:dbEncrpted forKey:@"DBEncrypted"];
}

+(BOOL)getIsDBEncrypted;
{
	[[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"DBEncrypted"];
}

+(NSString*)getBuildDate
{
    NSString *buildDate =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"BuildDate"];
	return buildDate;
}

+(NSString*)getGitCommit
{
    NSString *buildDate =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"GitCommit"];
	return buildDate;
}

+(void)setLoginState:(BOOL)loginState
{
    prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:loginState forKey:@"LoginState"];
}

+(BOOL)getLoginState
{
    [[NSUserDefaults standardUserDefaults] synchronize];
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs boolForKey:@"LoginState"];
}

+(void)setSessionID:(NSString*)accountID
{
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:accountID forKey:@"SessionID"];
}

+(NSString*)getSessionID
{
	prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:@"SessionID"];
}

+(void)setUserTopic
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *ts = [NSString stringWithFormat:@"%d", timestamp];
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:ts forKey:@"TSUserTopic"];
}

+(NSString*)getUserTopic
{
	prefs = [NSUserDefaults standardUserDefaults];
    if (prefs == nil)
    {
        return @"";
    }
	return [prefs objectForKey:@"TSUserTopic"];
}

+(NSString*)getAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+(NSString*)getBuildValue
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+(NSString*)getBuildVersion
{
    NSString * version = [self getAppVersion];
    NSString * build = [self getBuildValue];
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    if (![version isEqualToString: build])
    {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    return versionBuild;
}

@end
