//
//  NSException+Category.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : used to catch crashes, and save them in the DB for later upload to server.
//  Very handy.
//

#import <Foundation/Foundation.h>

@interface NSException (Category)

-(void)saveExceptionData;
-(NSString*)osVersionBuild;
-(NSString*)getHardwareModel;

@end
