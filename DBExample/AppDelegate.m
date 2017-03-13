//
//  AppDelegate.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : the main AppDelegate, this is always running, and always present.
//  Do all your networking and Server communication here, or extend this class as a Category.
//  The observeValueForKeyPath method is at the bottom for all of the AppConnectionOperation
//  NSOperations. A typical App will have lots of connections to talk to the Server over a
//  RESTFul API using JSON Objects, by the way don't use XML or you'll be sorry when you have
//  to decode it. JSON is typically one line of code to decode, XML is hundreds.
//

#import "AppDelegate.h"
#import "AppAnalytics.h"
#import "AppManager.h"
#import "SettingsModel.h"
#import <CommonCrypto/CommonDigest.h>

@implementation AppDelegate

#import "AppConstants.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Redefine the DB_FILE names
    DB_FILE = @"Companies.db";
    DB_FILEX = @"CompaniesX.db";
    
    //Set some fake user for now
    if(![SettingsModel getLoginState])
    {
        [SettingsModel setUserName:@"John Smith"];
        [SettingsModel setUserId:[NSNumber numberWithInt:1]];
        [SettingsModel setCountry:@"USA"];
    }
    
    NSString *userName = [SettingsModel getUserName];
    NSLog(@"AppDelegate : userName = %@",userName);
    
#ifdef ENCRYPT
    //Set this just once! These are required for SQLCipher and encryption since the passwords
    //are always used for the encryption keys plus some salt
    if(![SettingsModel getLoginState])
    {
        [SettingsModel setDBPW0:@"1260793RTgu"];
        [SettingsModel setDBPW1:@"1260793RTgu"];
    }
    [SettingsModel setDBCanEncrypt:YES];
#endif
    
    [SettingsModel setLoginState:YES];
    [AppManager InitializeAppManager];
    //Open the Database. Typically you wouldn't do this until a user has enter a password first
    //In the login or signin views. Never open the DB with Encryption until you have a password present.
    
    //Always open the DB when the App initializes, this applys the encryption keys if the DB is encrypted
    //so the DB can be read, this is only done once, but if called more then once it's no harm since
    //it will only execute once.
    [[AppManager SQLDataAccess] openConnection];
    [self configureAnalytics];
    
    return YES;
}

-(void) configureAnalytics
{
    //Sends all your Google Analytic data to Google. The identifier is in DBExample-Info.plist
    [AppAnalytics sharedInstance].optOut = YES;
    NSString *analyticsIdentifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AnalyticsIdentifier"];
    [[AppAnalytics sharedInstance] trackerWithName:@"DBExample" trackingId:analyticsIdentifier];
    [AppAnalytics sharedInstance].optOut = NO;//allow for analytics collection
    [AppAnalytics sharedInstance].dispatchInterval = 120;
    [AppAnalytics sharedInstance].trackUncaughtExceptions = YES;
    NSLog(@"Analytics Identifier = %@", analyticsIdentifier);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //Always Close the Database connection when the App goes down
    //This secures your data, and makes sure it can't get corrupted
    [[AppManager SQLDataAccess] closeConnection];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[AppManager SQLDataAccess] openConnection];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
