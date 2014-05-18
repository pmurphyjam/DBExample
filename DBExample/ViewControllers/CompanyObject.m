//
//  CompanyObject.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : This just prints out the CompanyObject in a pretty format in an NSLog.
//  It never prints out the companyThumbnail data just it's length.
//  All PNG images or photos should always be carried around in the App as NSData
//  and only converted to a UIView when displayed to save copious amounts of memory.
//
#import "CompanyObject.h"

@implementation CompanyObject

- (NSString*)description
{
	return [NSString stringWithFormat:@"CompanyObj \r: companyID = %@ \r: name = %@ \r: phoneMain = %@ \r: address = %@ \r: city = %@ \r: state = %@ \r: country = %@ \r: companyThumbnail[%d] ",self.companyID,self.name,self.phoneMain,self.address,self.city,self.state,self.country,[self.companyThumbnail length]];
}

@end
