//
//  AppQueryParameter.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppQueryParameter : NSObject
{
	NSNumber *parameterType;
}

@property(nonatomic, strong)NSNumber *parameterType;

-(id)initWithParameterType:(int)type;

@end
