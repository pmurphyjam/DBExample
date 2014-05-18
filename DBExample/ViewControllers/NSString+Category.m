//
//  NSString+Category.m
//  DBExample
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
#import "NSString+Category.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Category)

- (NSString *) stringFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString*)base64StringFromData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
			
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString*)stringFromData:(NSData*)data
{
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return string;
}

- (NSString *)repeatTimes:(NSUInteger)times {
    return [@"" stringByPaddingToLength:(times * [self length])
                             withString:self
                        startingAtIndex:0];
}

- (NSString*)stringByTrimmingLeadingZeroes {
    NSInteger i = 0;
    
    while ((i < [self length])
           && [[NSCharacterSet characterSetWithCharactersInString:@"0"]
               characterIsMember:[self characterAtIndex:i]])
    {
        i++;
    }
    return [self substringFromIndex:i];
}

- (BOOL)isNumeral {
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [self length]; i++) {
        unichar c = [self characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (BOOL)isOnlyFromCharacterSet:(NSCharacterSet *)aCharacterSet {
	NSString *s = [[self lowercaseString] copy];
	
	unichar c;
	for(NSUInteger i = 0; i < [s length]; i++) {
		[s getCharacters:&c range:NSMakeRange(i, 1)];
		if([aCharacterSet characterIsMember:c] == NO) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)isHexadecimal {
	NSCharacterSet *hexadecimalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"];
	return [self isOnlyFromCharacterSet:hexadecimalCharacterSet];
}

@end
