//
//  AppConstants.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Central place for all the App constants, and controls debug logs.
//  Simply comment in or out a debug log below to see log information to aid in quick debug.
//  Developer should define their own meaningful debug logs, like NTXLog for all transmit events, etc.
//

#import <Foundation/Foundation.h>

#define ServerUrl @"http://your.company.com/"
#define ServerDomain "yahoo.com"

#define DB_FILE                       @"Companies.db"
#define DB_FILEX                      @"CompaniesX.db"
#define DB_KEY                        @"24592ED456983DEAB4598234598EDC3F25098EF240975EDF4358297DEF245FDE"
#define EN_KEY                        @"3FEF5CA851E7B34E5670B023F08503493D451A05CE4D2EDC6833F666A8086BEC"
#define SQLITE_CIPHER_VERSION         3008000

#define GET_LAST_INSERTED_IDENTITY 1
#define GET_AND_SAVE_LAST_INSERTED_IDENTITY 2
#define RETRIEVE_SAVED_IDENTITY 3

#define SETTINGS_FILE                 @"Settings.plist"

//AppConnections
#define kCRASH_DATA_CONNECTION        @"CrashDataConnection"


//#define DEBUG
#ifdef DEBUG
#    define NDLog(...) NSLog(__VA_ARGS__)
#else
#    define NDLog(...)
#endif

//#define DEBUGNSQL
#ifdef DEBUGNSQL
#    define NSQLog(...) NSLog(__VA_ARGS__)
#else
#    define NSQLog(...)
#endif

//#define DEBUGDB
#ifdef DEBUGDB
#    define NSDBLog(...) NSLog(__VA_ARGS__)
#else
#    define NSDBLog(...)
#endif

//#define DEBUGCR
#ifdef DEBUGCR
#    define NCRLog(...) NSLog(__VA_ARGS__)
#else
#    define NCRLog(...)
#endif
