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
#import "NSString+Category.h"
#import "NSDictionary+JSONCategory.h"
#import "DeviceUtils.h"
#import "AppDebugLog.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>

@implementation AppDelegate

@synthesize operationQueue;
@synthesize crashDataConnection;

#import "AppConstants.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Set some fake passwords for now, these are required for SQLCipher and encryption since the passwords
    //are always used for the encryption keys plus some salt
    [SettingsModel setPW0:@"1260793RTgu"];
    [SettingsModel setDS0:[AppManager getSomeDSfromDate:[NSDate date]]];
    [SettingsModel setPW1:@"1260793RTgu"];
    [SettingsModel setDS1:[AppManager getSomeDSfromDate:[NSDate date]]];
    [SettingsModel setLoginState:YES];
    [SettingsModel setUserName:@"John Smith"];
    [AppManager InitializeAppManager];
    //Open the Database. Typically you wouldn't do this until a user has enter a password first
    //In the login or signin views. Never open the DB with Encryption until you have a password present.
    [[AppManager DataAccess] openConnection];
    [self configureAnalytics];
    
    //Upload CrashData if we have some
    if([SettingsModel getLoginState])
    {
        //If the App crashed it will come here, and see if there is any Stack Traces to upload to the Server
        BOOL crashDataExists = [AppManager crashDataExists];
        if(crashDataExists)
            [self uploadCrashDataInfo];
    }
    
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

#pragma mark CrashData

-(void)uploadCrashDataInfo
{
    NCRLog(@"AppDel : uploadCrashDataInfo ");
#ifdef DEV
    NSString *mode = @"dev";
#else
    NSString *mode = @"prod";
#endif
    NSMutableArray *crashDataArray = [AppManager getCrashData];
    for(NSDictionary *crashDic in crashDataArray)
    {
        NCRLog(@"AppDel : uploadCrashDataInfo : crashDic = %@",crashDic);
        NSString *messageID = [NSString stringWithFormat:@"%@",[crashDic objectForKey:@"ID"]];
        NSData *jsonData = [crashDic toJSON];
        NSString *jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSString *params =[NSString stringWithFormat:@"mode=%@&session_id=%@&json=%@", mode,[[SettingsModel getSessionID] urlencode], jsonString];
        NSString *methodStr = [NSString stringWithFormat:@"user/crash/?%@",[SettingsModel getAccountID]];
        crashDataConnection = [[AppConnectionOperation alloc]initWithRequest:[AppDelegate sendPOSTRequest:params method:methodStr] forConnection:kCRASH_DATA_CONNECTION];
        [crashDataConnection setMessageID:messageID];
        [crashDataConnection addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
        [operationQueue addOperation:crashDataConnection];
    }
}

+(NSMutableURLRequest*)sendPOSTRequest:(NSString*)params method:(NSString*)method
{
    NSURL *url = [NSURL URLWithString:[DeviceUtils getURL:method]];
    NSString *post = [DeviceUtils getPostHash:params];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:postData];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[theRequest setTimeoutInterval:20.0];
	return theRequest;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//This is used by the AppConnectionOperation. All your Server communication should go here, just create more connection's, and
//add more else if's for the decode of each, it typically get's quite large.
//Because these reside in the AppDelegate these connections will always complete, if you do this in a view controller, and the
//user exits the view during a connection operation the App will likely crash, thus having all of them here is much safer.
//The same can be achieved with NSURLSession, but this only works on iOS7.0 and above.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)operation change:(NSDictionary *)change context:(void *)context
{
    if ([operation isKindOfClass:[AppConnectionOperation class]])
    {
        AppConnectionOperation *appConnectionOperation = (AppConnectionOperation *)operation;
        NSString *connectionName = [appConnectionOperation connectionName];
        NSData *data = [appConnectionOperation data];
        NSString *messageID = [appConnectionOperation messageID];
        //Not using these so comment them out for now
        //NSString *errorMessage = [appConnectionOperation errorMessage];
        //NSDictionary *messageDic = [appConnectionOperation messageDic];
        //NSMutableArray *messageArray = [appConnectionOperation messageArray];
        NSError *error = [appConnectionOperation error];
        BOOL status = [appConnectionOperation status];
        NDLog(@"AppDelChat : connectionName = %@ ",connectionName);
        
        if ([connectionName isEqualToString:kCRASH_DATA_CONNECTION])
        {
            if (error != nil)
            {
                NSLog(@"AppDelChat : Crash Data Internet Connection Error");
                [AppDebugLog writeDebugData:[NSString stringWithFormat:@"Crash Data Internet Connection Error"]];
            }
            else if (!status)
            {
                NSLog(@"AppDelChat : Crash Data Connection Error");
                [AppDebugLog writeDebugData:[NSString stringWithFormat:@"Crash Data Connection Error"]];
            }
            else
            {
                //Status Good
                NSError *err;
                NSDictionary *json = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:kNilOptions
                                       error:&err];
                
                if (!json)
                {
                    NSLog(@"AppDelChat : CRASH_DATA_CONNECTION : Error parsing JSON: %@ : %@", err,[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding]);
                }
                else
                {
                    NCRLog(@"AppDelChat : CRASH_DATA_CONNECTION : messageID = %@", messageID);
                    if([json count] > 0)
                    {
                        NCRLog(@"AppDelChat : CRASH_DATA_CONNECTION : jsonArray = %@", json);
                        //All we're looking for is {'status' : 'ok'}
                        //Then this crash is updated via the ID, and sync_bit = 1 so it's not uploaded again.
                        if([[json objectForKey:@"status"] isEqualToString:@"ok"])
                            [AppManager updateCrashData:messageID];
                    }
                }
            }
        }
        
        if ([operation isEqual:crashDataConnection])
        {
            //You always need to remove the observer, and do a cancel to properly terminate a connection
            NCRLog(@"AppDelChat : Get Crash Data Connection Operation : Finished");
            [crashDataConnection removeObserver:self forKeyPath:@"isFinished"];
            [crashDataConnection cancel];
        }

    }//AppConnectionOperation
    
}

@end
