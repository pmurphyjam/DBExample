//
//  NSString+Category.h
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
//  Info : Category to extend NSString with some handy methods.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

+(NSString*)hashedValue:(NSString *)value uppercase:(BOOL)uppercase;
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
