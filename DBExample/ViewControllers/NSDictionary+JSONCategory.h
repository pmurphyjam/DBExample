//
//  NSDictionary+JSONCategory.h
//  DBExample
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//
//  Info : Category to extend NSDictionary with some handy JSON conversion methods.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONCategory)

+(NSDictionary*)fromJSON:(NSString*)jsonString;
-(NSData*)toJSON;

@end
