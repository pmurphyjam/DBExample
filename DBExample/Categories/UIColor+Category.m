//
//  UIColor+Category.m
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2017 Fitamatic All rights reserved.
//
#import "UIColor+Category.h"
#import "NSString+Category.h"

@implementation UIColor (Category)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

+(UIColor*)colorWithHexRGB:(NSString*)hexRGB  AndAlpha:(float)alpha
{
    UIColor *theColor = [UIColor whiteColor];
    if([hexRGB length] > 5)
    {
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [hexRGB substringWithRange:range];
        range.location = 2;
        NSString *gString = [hexRGB substringWithRange:range];
        range.location = 4;
        NSString *bString = [hexRGB substringWithRange:range];
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        theColor = [UIColor colorWithRed:((float) r / 255.0f)
                                   green:((float) g / 255.0f)
                                    blue:((float) b / 255.0f)
                                   alpha:alpha];
        
    }
    return theColor;
}

+(NSString*)getHexColor:(UIColor*)color
{
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	NSString *hexColorStr = [NSString stringWithFormat:@"%f%f%f",components[0],components[1],components[2]];
	return hexColorStr;
}

+(UIColor*) getColorFrom:(UIColor*)inputColor add:(CGFloat)addValue
{
	const CGFloat *components = CGColorGetComponents(inputColor.CGColor);
	UIColor *newColor = RGBA(components[0]+addValue, components[1]+addValue, components[2]+addValue, components[3]);
	return newColor;
}

+ (UIColor *)colorWithWebColor:(NSInteger)rgbValue {
	return [UIColor colorWithRed:((double)((rgbValue & 0xFF0000) >> 16))/255.0
						   green:((double)((rgbValue & 0xFF00) >> 8))/255.0
							blue:((double)(rgbValue & 0xFF))/255.0
						   alpha:1.0];
}

+ (UIColor *)colorWithWebColorString:(NSString *)hexColor {
	NSString *s = [hexColor copy];
	
    if ([s hasPrefix:@"#"]) s = [hexColor substringFromIndex:1];
    if ([s hasPrefix:@"0x"]) s = [hexColor substringFromIndex:2];
	
	if ([s isHexadecimal] == NO) return nil;
    if ([s length] != 6) return nil;
	
	int i = 0;
	sscanf([s cStringUsingEncoding:NSUTF8StringEncoding], "%x", &i);
	
    return [UIColor colorWithWebColor:i];
}

@end
