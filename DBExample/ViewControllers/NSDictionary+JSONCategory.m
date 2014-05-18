//
//  NSDictionary+JSONCategory.m
//  DBExample
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//

#import "NSDictionary+JSONCategory.h"

@implementation NSDictionary (JSONCategory)

+(NSDictionary*)fromJSON:(NSString*)jsonString
{
	NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
	id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
