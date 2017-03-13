//
//  SettingsModel+Category.m
//  Category extension of SettingsModel
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Centralized Settings for the App, stored in a plist.
//

#import "SettingsModel+Category.h"
#import "AppManager.h"
#import "AppDateFormatter.h"

@implementation SettingsModel (SettingsModel)

+(void)setAccountID:(NSString*)accountID
{
    [[[SettingsModel settings] prefs] setObject:accountID forKey:@"AccountID"];
}

+(NSString*)getAccountID
{
	return [[[SettingsModel settings] prefs]  objectForKey:@"AccountID"];
}

+(void)setFirstName:(NSString*)firstName
{
	[[[SettingsModel settings] prefs]  setObject:firstName forKey:@"FirstName"];
}

+(NSString*)getFirstName
{
	return [[[SettingsModel settings] prefs]  objectForKey:@"FirstName"];
}

+(void)setLastName:(NSString*)lastName
{
	[[[SettingsModel settings] prefs]  setObject:lastName forKey:@"LastName"];
}

+(void)setEmailAddress:(NSString*)emailAddress
{
	[[[SettingsModel settings] prefs]  setObject:emailAddress forKey:@"EmailAddress"];
}

+(NSString*)getEmailAddress
{
    NSString *emailAddress = [[[SettingsModel settings] prefs]  objectForKey:@"EmailAddress"];
    return emailAddress;
}

+(NSString*)getLastName
{
	return [[[SettingsModel settings] prefs]  objectForKey:@"LastName"];
}

+(void)setTotalUserContacts:(NSNumber*)totalUserContacts
{
	[[[SettingsModel settings] prefs]  setObject:totalUserContacts forKey:@"TotalUserContacts"];
}

+(NSNumber*)getTotalUserContacts
{
    return [[[SettingsModel settings] prefs]  objectForKey:@"TotalUserContacts"];
}

+(void)setProcessingContacts:(BOOL)processingContacts
{
	[[[SettingsModel settings] prefs]  setBool:processingContacts forKey:@"ProcessingContacts"];
}

+(BOOL)getProcessingContacts
{
	return [[[SettingsModel settings] prefs]  boolForKey:@"ProcessingContacts"];
}

+(void)setTotalCalendarEvents:(NSNumber*)totalCalendarEvents
{
	[[[SettingsModel settings] prefs]  setObject:totalCalendarEvents forKey:@"TotalCalendarEvents"];
}

+(NSNumber*)getTotalCalendarEvents
{
	return [[[SettingsModel settings] prefs]  objectForKey:@"TotalCalendarEvents"];
}

+(void)setCalendarAuthorization:(BOOL)calendarAuthorization
{
	[[[SettingsModel settings] prefs]  setBool:calendarAuthorization forKey:@"CalendarAuthorization"];
}

+(BOOL)getCalendarAuthorization
{
	return [[[SettingsModel settings] prefs]  boolForKey:@"CalendarAuthorization"];
}

+(void)setProcessingCalendarEvents:(BOOL)processingCalendar
{
	[[[SettingsModel settings] prefs]  setBool:processingCalendar forKey:@"ProcessingCalendar"];
}

+(BOOL)getProcessingCalendarEvents
{
    return [[[SettingsModel settings] prefs]  boolForKey:@"ProcessingCalendar"];
}

@end
