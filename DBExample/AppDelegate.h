//
//  AppDelegate.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConnectionOperation.h"

#define AppDelegates (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSOperationQueue *operationQueue;
    AppConnectionOperation *crashDataConnection;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) AppConnectionOperation *crashDataConnection;

+(NSMutableURLRequest*)sendPOSTRequest:(NSString*)params method:(NSString*)method;

@end
