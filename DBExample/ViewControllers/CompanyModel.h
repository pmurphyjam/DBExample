//
//  CompanyModel.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
// Info : Controls all accesses to the Companys table.
// Should have an Select(get), Insert, Update, and Delete for all tables, and deal only with CompanyObjects.
// Similar in construct to ORMLite for Android.
//

#import <Foundation/Foundation.h>
#import "CompanyObject.h"

@interface CompanyModel : NSObject

+(BOOL)insertCompany:(CompanyObject*)companyObject;
+(NSMutableArray*)getCompanysForView;
+(BOOL)updateCompany:(CompanyObject*)companyObject;
+(BOOL)deleteCompany:(CompanyObject*)companyObject;

@end
