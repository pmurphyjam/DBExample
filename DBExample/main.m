//
//  main.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : main program, uses NSException process to save a symbolicated crash and
//  store this data into the DB. This data can then be loaded up to the Server later.
//  The method to do the upload is in AppDelegate : uploadCrashDataInfo
//  The Server would have to exist for this to work though.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
