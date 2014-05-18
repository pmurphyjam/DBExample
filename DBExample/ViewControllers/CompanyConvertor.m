//
//  CompanyConvertor.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import "CompanyConvertor.h"
#import "CompanyObject.h"

@implementation CompanyConvertor

-(NSMutableArray*)convertToObjects:(NSArray*)companyArray
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[companyArray count]];
    for (NSDictionary *contact  in companyArray) {
        CompanyObject *companyObj = [[CompanyObject alloc] init];
        companyObj.companyID = contact[@"companyID"];
        companyObj.name = contact[@"name"];
        companyObj.phoneMain = contact[@"phoneMain"];
        companyObj.address = contact[@"address"];
        companyObj.city = contact[@"city"];
        companyObj.state = contact[@"state"];
        companyObj.country = contact[@"country"];
        companyObj.companyThumbnail = contact[@"companyThumbnail"];
        [objects addObject:companyObj];
    }
    return objects;
}

@end
