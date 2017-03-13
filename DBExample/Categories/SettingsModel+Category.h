//
//  SettingsModel+Category.h
//  Category extension of SettingsModel
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsModel.h"

@interface SettingsModel  (SettingsModel)

+(void)setAccountID:(NSString*)userID;
+(NSString*)getAccountID;
+(void)setEmailAddress:(NSString*) password;
+(NSString*)getEmailAddress;
+(void)setFirstName:(NSString*)loginName;
+(NSString*)getFirstName;
+(void)setLastName:(NSString*)loginName;
+(NSString*)getLastName;
+(void)setTotalUserContacts:(NSNumber*)totalUserContacts;
+(NSNumber*)getTotalUserContacts;
+(void)setProcessingContacts:(BOOL)processingContacts;
+(BOOL)getProcessingContacts;
+(void)setTotalCalendarEvents:(NSNumber*)totalCalendarEvents;
+(NSNumber*)getTotalCalendarEvents;
+(void)setCalendarAuthorization:(BOOL)calendarAuthorization;
+(BOOL)getCalendarAuthorization;
+(void)setProcessingCalendarEvents:(BOOL)processingCalendar;
+(BOOL)getProcessingCalendarEvents;

@end
