//
//  NSException+Category.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "NSException+Category.h"
#import "AppManager.h"
#import "SettingsModel.h"
#import "GTMStackTrace.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#include <unistd.h>
#import <sys/utsname.h>
#include <sys/sysctl.h>

@implementation NSException (Category)

-(NSString*)getHardwareModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)osVersionBuild {
	int mib[2] = {CTL_KERN, KERN_OSVERSION};
	size_t size = 0;
	sysctl(mib, 2, NULL, &size, NULL, 0);
	char *answer = malloc(size);
	sysctl(mib, 2, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

- (void)saveExceptionData
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *crashInfoStr = [NSString stringWithFormat:@" name = %@ : reason = %@ : info = %@",[self name],[self reason],[self userInfo]];
	NSString *stackTraceStr = GTMStackTraceFromException(self);
    NSString *hardwareModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	NSString *osVersion = [NSString stringWithFormat:@"iOS %@ (%@)",[[UIDevice currentDevice] systemVersion],[self osVersionBuild]];
	NSString *pid = [NSString stringWithFormat:@"%d",[[NSNumber numberWithInt:getpid()] intValue]];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	NSString *processStr = [NSString stringWithFormat:@"%@[%@]",appName,pid];
    NSDictionary *crashDic = [NSDictionary dictionaryWithObjectsAndKeys:crashInfoStr,@"CrashInfo",stackTraceStr,@"StackTrace",hardwareModel,@"HardwareModel",osVersion,@"OSVersion",appVersion,@"AppVersion",processStr,@"ProcessID",nil];
    if([SettingsModel getLoginState])
        [AppManager saveExceptionData:crashDic];
}

@end
