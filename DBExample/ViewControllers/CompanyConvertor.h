//
//  CompanyConvertor.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Company Convertor. Creates CompanyObject's from the DB.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>

@interface CompanyConvertor : NSObject

-(NSMutableArray*)convertToObjects:(NSArray*)contactsArray;

@end
