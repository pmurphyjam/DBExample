//
//  NSString+Category.h
//  DBExample
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Category to extend NSString with some handy methods.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

-(NSString*)stringFromMD5;
+(NSString*)base64StringFromData:(NSData*)theData;
+(NSString*)stringFromData:(NSData*)data;
-(NSString*)repeatTimes:(NSUInteger)times;
-(NSString*)stringByTrimmingLeadingZeroes;
-(BOOL)isNumeral;
-(NSString*)urlencode;
-(BOOL)isHexadecimal;
-(BOOL)isOnlyFromCharacterSet:(NSCharacterSet *)aCharacterSet;

@end
