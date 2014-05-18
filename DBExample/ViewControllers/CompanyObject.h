//
//  CompanyObject.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Creates a Company Object from the DB Companys table, 1-1 mapping.
//  All DB Tables should have this, similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>

@interface CompanyObject : NSObject

@property (nonatomic,strong) NSString *companyID;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phoneMain;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSData *companyThumbnail;

@end
