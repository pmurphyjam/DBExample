//
//  AppQueryParameter.m
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Used for getting the last paramter, etc
//
#import "AppQueryParameter.h"

@implementation AppQueryParameter

@synthesize parameterType;

-(id)initWithParameterType:(int)type
{
	if (self = [super init])
    {
		parameterType = [NSNumber numberWithInt:type];
	}
	return self;
}

@end
