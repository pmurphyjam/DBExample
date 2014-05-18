//
//  NSData+Category.h
//  DBExample
//
//  Created by Pat Murphy on 5/16/14.
//  Copyright (c) 2014 Fitamatic All rights reserved.
//
//  Info : Category to extend NSData with some handy methods.
//
#import <Foundation/Foundation.h>
#include <zlib.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Category)

-(NSData*)gzipInflate;
-(NSData*)gzipDeflate;
+(NSData*)base64DataFromString:(NSString *)string;
+(NSData*)dataFromString:(NSString *)string;
+(NSData*)scaleDataImage:(NSData *)imageData toSize:(CGSize)newSize;
+(NSData*)scaleDataImage:(NSData *)imageData forSize:(CGSize)newSize;;
+(NSData*)dataFromBase64String:(NSString *)aString;
-(NSString*)base64EncodedString;


@end
