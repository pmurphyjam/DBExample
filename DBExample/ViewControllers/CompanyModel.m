//
//  CompanyModel.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "CompanyModel.h"
#import "AppManager.h"
#import "CompanyConvertor.h"

@implementation CompanyModel

+(BOOL)insertCompany:(CompanyObject*)companyObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"insert into Companys (sync_bit,sync_delete,sync_datetime,name,phoneMain,address,city,state,country,companyThumbnail) values(?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[companyObject name],[companyObject phoneMain],[companyObject address],[companyObject city],[companyObject state],[companyObject country],[companyObject companyThumbnail],nil];
    return status;
}

+(BOOL)updateCompany:(CompanyObject*)companyObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"update Companys set sync_bit = ?,sync_delete = ?,sync_datetime = ?,companyID = ?,name = ?,phoneMain = ?,address = ?,city = ?,state = ?,companyThumbnail = ?  where companyID = ?",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO],[AppManager UTCDateTime],[companyObject companyID],[companyObject name],[companyObject phoneMain],[companyObject address],[companyObject city],[companyObject state],[companyObject companyThumbnail],[companyObject companyID],nil];
    return status;
}

+(BOOL)deleteCompany:(CompanyObject*)companyObject
{
    BOOL status = [[AppManager SQLDataAccess] ExecuteStatement:@"delete from Companys where companyID = ?",[companyObject companyID],nil];
    return status;
}

+(NSMutableArray*)getCompanysForView
{
    NSMutableArray *companyArray = [[AppManager SQLDataAccess] GetRecordsForQuery:@"select * from Companys",nil];
    CompanyConvertor *companyConvertor = [[CompanyConvertor alloc] init];
    NSMutableArray *companyConvertorArray = [companyConvertor convertToObjects:companyArray];
    return companyConvertorArray;
}

@end
