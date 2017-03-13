//
//  DBConstants.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Central place for all the App constants, and controls debug logs.
//  Simply comment in or out a debug log below to see log information to aid in quick debug.
//  Developer should define their own meaningful debug logs, like NTXLog for all transmit events, etc.
//

//#define DEBUG
#ifdef DEBUG
#    define NDLog(...) NSLog(__VA_ARGS__)
#else
#    define NDLog(...)
#endif


//#define DEBUGCR
#ifdef DEBUGCR
#    define NCRLog(...) NSLog(__VA_ARGS__)
#else
#    define NCRLog(...)
#endif
