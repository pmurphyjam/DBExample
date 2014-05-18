//
//  AppManager.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Manages the app. Opens the data base also.
//  Has lots of DateFormatter methods since the DB must always store dates in UTC format.
//

#import "AppManager.h"
#import "DataAccess.h"
#import "AppDebugLog.h"
#import <CommonCrypto/CommonCryptor.h>
#import "SettingsModel.h"
#import <mach/mach.h>
#import "AppDateFormatter.h"

@implementation AppManager

__strong static DataAccess *dataAccess;
__strong static UTCDate *utcDate;
__strong static AppDateFormatter *dateFormatter = nil;

//#define DEBUG
#import "AppConstants.h"

+(void) InitializeAppManager
{
	dataAccess = [[DataAccess alloc]init];
	utcDate = [[UTCDate alloc] init];
    dateFormatter = [[AppDateFormatter alloc] init];
}

+(BOOL) OpenDBConnection;
{
	return [dataAccess openConnection];
}

+(void) CloseDBConnection
{
	[dataAccess closeConnection];
}

+(void) KillDB
{
	[dataAccess killDB];
}

+(DataAccess*) DataAccess
{
	return dataAccess;
}

+(void) Finalize
{
	[DataAccess finalize];
}

+(BOOL) IPad
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
    return NO;
}

+(int) AppDefinitionID
{
    if([AppManager IPad])
    {
        return 2; //iPad
    }
    else
    {
        return 1; //iPhone
    }
}

+(NSString *) UTCDateTime
{
	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	[dateFormatter setTimeZone:utc];
	NSString *UTCDatetime = [dateFormatter stringFromDate:[NSDate date]];
	return UTCDatetime;
}

+(NSString *) CurrentDateTime
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
	dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	NSString *UTCDatetime = [dateFormatterInst stringFromDate:[NSDate date]];
	return UTCDatetime;
}

+(NSString*) getUTCDateTimeForDate:(NSDate*)date
{
	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	[dateFormatter setTimeZone:utc];
	NSString *UTCDatetime = [dateFormatter stringFromDate:date];
	return UTCDatetime;
}

+(NSDate*) getUTCDateTimeFromDateString:(NSString*)dateStr
{
	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	[dateFormatter setTimeZone:utc];
	NSDate *UTCDatetime = [dateFormatter dateFromString:dateStr];
	return UTCDatetime;
}

+(NSDate*) getDateFromDateString:(NSString*)dateStr
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
	dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	NSDate *UTCDatetime = [dateFormatterInst dateFromString:dateStr];
	return UTCDatetime;
}

+(NSString*) getDateStringFromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
	dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	NSString *UTCDatetime = [dateFormatterInst stringFromDate:date];
	return UTCDatetime;
}

+(NSString *) getSectionHeaderfromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    dateFormatterInst.dateFormat = @"yyyy-MM-dd";
	NSString *datetime = [dateFormatterInst stringFromDate:date];
	return datetime;
}

+(NSString*) getMidNightForDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                   fromDate:date];
    
    NSDate *midnightUTC = [calendar dateFromComponents:dateComponents];
    
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    dateFormatterInst.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormatterInst.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    return [dateFormatterInst stringFromDate:midnightUTC];
}

+(NSString *) getSomeDSfromDate:(NSDate*)date
{
    AppDateFormatter *dateFormatterInst = [[AppDateFormatter alloc] init];
    dateFormatterInst.dateFormat = @"dd-yyyy-MM HH:mm";
    NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatterInst setTimeZone:utc];
	NSString *datetime = [dateFormatterInst stringFromDate:date];
	return datetime;
}

+(UTCDate *) UTCDate
{
	return utcDate;
}

+(NSString*)PathForFileWithName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *pathForFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return pathForFile;
}

+(BOOL)DoesFileExistWithName:(NSString*)fileName
{
    BOOL status = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *pathForFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    if(![fileManager fileExistsAtPath:pathForFile])
        status = NO;
    return status;
}

+(NSDate*)dateForUTCDateString:(NSString*)dateString
{
    AppDateFormatter *dateFormatterUTC = [[AppDateFormatter alloc] init];
    [dateFormatterUTC setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatterUTC setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [dateFormatterUTC dateFromString:dateString];
    return date;
}

+(NSTimeInterval) UTCOffsetForDate:(NSString*)dateString
{
    AppDateFormatter *dateFormatter = [[AppDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeInterval deviceGMTOffset = [[NSTimeZone localTimeZone] secondsFromGMTForDate:date];
    return deviceGMTOffset;
}

+(NSMutableData*)AES256Encrypt:(NSString*)plainText
{
    NSString *key = EN_KEY;
	char keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    NSMutableData *data = [NSMutableData dataWithData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
	
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [data length];
	
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
    CCCryptorStatus result = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL,
                                     [data mutableBytes], [data length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
	
    NSMutableData *output = [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	if( result == kCCSuccess )
	{
		return output;
	}
    return NULL;
}

+(NSString*)AES256Decrypt:(NSMutableData*)encryptData
{
    NSString *key = EN_KEY;
	char  keyPtr[kCCKeySizeAES256+1];
    bzero( keyPtr, sizeof(keyPtr) );
    
    NSMutableData *data = encryptData;
    
    [key getCString: keyPtr maxLength: sizeof(keyPtr) encoding: NSUTF8StringEncoding];
    
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer_decrypt = malloc(bufferSize);
    
    CCCryptorStatus result = CCCrypt( kCCDecrypt , kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeAES256,
                                     NULL,
                                     [data mutableBytes], [data length],
                                     buffer_decrypt, bufferSize,
                                     &numBytesEncrypted );
    
    NSMutableData *output_decrypt = [NSMutableData dataWithBytesNoCopy:buffer_decrypt length:numBytesEncrypted];
    if( result == kCCSuccess )
    {
        return [[NSString alloc] initWithData:output_decrypt encoding:NSUTF8StringEncoding];
    }
    return NULL;
}

+(void)currentMemoryConsumption:(NSString*)executionPoint
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&info,&size);
	
	mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
	
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
	natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
	
	[AppDebugLog writeDebugData:[NSString stringWithFormat:@"Memory : %@ Cons:Free:Used:Total: %0.2f : %0.2f : %0.2f : %0.2f MBs",executionPoint,info.resident_size/(1024.0*1024.0),mem_free/(1024.0*1024.0),mem_used/(1024.0*1024.0),info.virtual_size/(1024.0*1024.0)]];
}

+(NSDictionary*)crashDataExistsSQL
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" select ID from CrashData where sync_bit = 1 "];
	NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys: sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(BOOL)crashDataExists
{
    BOOL status = NO;
    NSDictionary *sqlAndParams = [self crashDataExistsSQL];
	NSMutableArray *usersArray = [[AppManager DataAccess] GetRecordsForQuery:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    if([usersArray count] > 0)
        status = YES;
    return status;
}

+(NSDictionary*)getCrashDataSQL
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" select ID,crashInfo,stackTrace,hardwareModel,osVersion,appVersion,userID,userName,processID,buildDate,gitCommit,sync_datetime from CrashData where sync_bit = 1 "];
	NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys: sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(NSMutableArray*)getCrashData
{
    NSDictionary *sqlAndParams = [self getCrashDataSQL];
	NSMutableArray *chatsArray = [[AppManager DataAccess] GetRecordsForQuery:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return chatsArray;
}

+(NSDictionary*)updateCrashDataSQL:(NSString*)crashID
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" update CrashData set sync_bit = 0 where sync_bit = 1 and ID = ?"];
    [parameters addObject:crashID];
	NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys: sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(BOOL)updateCrashData:(NSString*)crashID
{
    NSDictionary *sqlAndParams = [self updateCrashDataSQL:crashID];
	BOOL status = [[AppManager DataAccess] ExecuteStatement:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
    return status;
}

+(NSDictionary*)insertCrashDataSQL:(NSDictionary*)crashInfo
{
    NSMutableString *sql = [NSMutableString string];
	NSMutableArray *parameters = [NSMutableArray array];
	[sql appendString:@" insert into CrashData (crashInfo, stackTrace,hardwareModel,osVersion,appVersion,processID,sync_bit,sync_delete,sync_datetime,buildDate,gitCommit, userID,user,userEmail,userName) values(?,?,?,?,?,?,?,?,?,?,?"];
    [parameters addObject:[crashInfo objectForKey:@"CrashInfo"]];
    [parameters addObject:[crashInfo objectForKey:@"StackTrace"]];
    [parameters addObject:[crashInfo objectForKey:@"HardwareModel"]];
    [parameters addObject:[crashInfo objectForKey:@"OSVersion"]];
    [parameters addObject:[crashInfo objectForKey:@"AppVersion"]];
    [parameters addObject:[crashInfo objectForKey:@"ProcessID"]];
    [parameters addObject:[NSNumber numberWithBool:YES]];
    [parameters addObject:[NSNumber numberWithBool:NO]];
    [parameters addObject:[AppManager UTCDateTime]];
    [parameters addObject:[SettingsModel getBuildDate]];
    [parameters addObject:[SettingsModel getGitCommit]];
    
    //All these should be there, but checking just in case
    if([SettingsModel getAccountID] != nil)
    {
        [parameters addObject:[SettingsModel getAccountID]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[SettingsModel getUserName] length] > 1)
    {
        [parameters addObject:[SettingsModel getUserName]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[SettingsModel getEmailAddress] length] > 1)
    {
        [parameters addObject:[SettingsModel getEmailAddress]];
        [sql appendString:@",?"];
    }
    else
    {
        [sql appendString:@",NULL"];
    }
    
    if([[SettingsModel getFirstName] length] > 1 && [[SettingsModel getLastName] length] > 1 )
    {
        NSString *smugName = [NSString stringWithFormat:@"%@ %@",[SettingsModel getFirstName],[SettingsModel getLastName]];
        [parameters addObject:smugName];
        [sql appendString:@",?)"];
    }
    else
    {
        [sql appendString:@",NULL)"];
    }
    
    NSDictionary *sqlAndParams = [NSDictionary dictionaryWithObjectsAndKeys:sql, @"SQL", parameters, @"Parameters", nil];
	return sqlAndParams;
}

+(BOOL)insertCrashData:(NSDictionary*)crashInfo
{
    NSDictionary *sqlAndParams = [self insertCrashDataSQL:crashInfo];
	BOOL status = [[AppManager DataAccess] ExecuteStatement:[sqlAndParams objectForKey:@"SQL"] WithParameters:[sqlAndParams objectForKey:@"Parameters"]];
	return status;
}

+(void)saveExceptionData:(NSDictionary*)crashDic
{
    NSLog(@"NSException : CrashInfo : \n%@",[crashDic objectForKey:@"CrashInfo"]);
    NSLog(@"NSException : StackTrace : \n%@",[crashDic objectForKey:@"StackTrace"]);
    [self insertCrashData:crashDic];
}

@end
