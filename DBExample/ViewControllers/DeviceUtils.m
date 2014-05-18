//
//  DeviceUtils.m
//  DBExample
//
//  Created by Pat Murphy on 5/17/14.
//  Copyright (c) 2014 Pat Murphy. All rights reserved.
//
//  Info : Various sundry device utility methods you always need since Apple can be an AppHole sometimes.
//

#import "DeviceUtils.h"
#import "SettingsModel.h"
#import "NSString+Category.h"
#import <CFNetwork/CFNetwork.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <AudioToolbox/AudioToolbox.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include<unistd.h>
#include<netdb.h>

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif

@implementation UIDevice(machine)

#import "AppConstants.h"

-(NSString*)machine
{
	size_t size;
	// Set 'oldp' parameter to NULL to get the size of the data
	// returned so we can allocate appropriate amount of space
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	// Allocate the space to store name
	char *name = malloc(size);
	// Get the platform name
	sysctlbyname("hw.machine", name, &size, NULL, 0);
	// Place name into a string
	NSString *machine = [NSString stringWithCString:name encoding: NSUTF8StringEncoding];
	// Done with this
	free(name);
	return machine;
}

@end

@implementation DeviceUtils

int main(int argc, char *argv[]);
static inline BOOL is_encrypted()
{
    const struct mach_header *header;
    Dl_info dlinfo;
    if (dladdr((void *)main, &dlinfo) == 0 || dlinfo.dli_fbase == NULL)
    {
        return NO;
    }
    header = (struct mach_header *)dlinfo.dli_fbase;
    struct load_command *cmd = (struct load_command *) (header+1);
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++)
    {
        if (cmd->cmd == LC_ENCRYPTION_INFO)
        {
            struct encryption_info_command *crypt_cmd = (struct encryption_info_command *)cmd;
            if (crypt_cmd->cryptid < 1)
            {
                return NO;
            }
            return YES;
        }
        cmd = (struct load_command *)((uint8_t *) cmd + cmd->cmdsize);
    }
    return NO;
}

+(BOOL)isDeviceEncrypted {
    return is_encrypted();
}

char* getMacAddress(char* macAddress, char* ifName)
{
	int  success, i;
	struct ifaddrs * addrs;
	struct ifaddrs * cursor;
	const struct sockaddr_dl * dlAddr;
	const unsigned char* base;
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != 0) {
			if ( (cursor->ifa_addr->sa_family == AF_LINK)
				&& (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName, cursor->ifa_name)==0 ) {
				dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
				base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
				strcpy(macAddress, "");
				for (i = 0; i < dlAddr->sdl_alen; i++) {
					if (i != 0) {
						strcat(macAddress, ":");
					}
					char partialAddr[3];
					sprintf(partialAddr, "%02X", base[i]);
					strcat(macAddress, partialAddr);
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return macAddress;
}

+(NSString*)rawMacAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        NDLog(@"Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        NDLog(@"Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL)
    {
        NDLog(@"Error : Could not allocate memory\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        NDLog(@"Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+(NSString*)getURL: (NSString *)method
{
    return [NSString stringWithFormat:@"%@%@", ServerUrl, method];
}

+(NSString*)getPostHashAfterhHash: (NSString *)params
{
    return [NSString stringWithFormat:@"%@&hhash=%@",params,[self hashedValue:[NSString stringWithFormat:@"%@%@", params,[self get_log_i]] uppercase:YES]];
}

+(NSString*)getPostHash:(NSString*)params
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    params = [params stringByAppendingString:[self getArk]];
    return [NSString stringWithFormat:@"%@&e=1&hhash=%@&lan=%@&bv=%@&av=%@&build=%@&os=ios&session_id=%@&userts=%@",params,[self hashedValue:[NSString stringWithFormat:@"%@%@", params,[self get_log_i]] uppercase:YES],[language urlencode], [SettingsModel getBuildVersion], [SettingsModel getBuildValue], [SettingsModel getAppVersion], [[SettingsModel getSessionID] urlencode], [SettingsModel getUserTopic]];
}

+(NSMutableDictionary*)getPostHashParams:(NSMutableDictionary*)params
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:[language urlencode] forKey:@"lan"];
    [_params setObject:[SettingsModel getBuildVersion] forKey:@"bv"];
    [_params setObject:@"1" forKey:@"e"];
    [_params setObject:[SettingsModel getBuildValue] forKey:@"build"];
    [_params setObject:[SettingsModel getAppVersion] forKey:@"av"];
    [_params setObject:@"1.0" forKey:@"os"];
    if ( [SettingsModel getSessionID] != nil)
    {
        [_params setObject:[SettingsModel getSessionID] forKey:@"session_id"];
    }
    [_params addEntriesFromDictionary:params];
    return _params;
}

+(NSString *)getArk
{
    NSMutableString *arkIDFA = [NSMutableString string];
    [arkIDFA setString:[NSString stringWithFormat:@"&ark=%@", [self hashedMAC:YES colons:YES]]];
    Class identifierClass = (NSClassFromString(@"ASIdentifierManager"));
    if (identifierClass != nil)
    {
        [arkIDFA appendString:[NSString stringWithFormat:@"&uaid=%@", [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]]];
    }
    return arkIDFA;
}

+(NSString*)getSessionId
{
    NSMutableString *sessionStr = [NSMutableString string];
    if([SettingsModel getSessionID] != nil)
    {
        [sessionStr setString:[NSString stringWithFormat:@"&session_id=%@", [[SettingsModel getSessionID] urlencode]]];
    }
    return sessionStr;
}

+(NSString*)getArkOrIDFA
{
    NSMutableString *arkIDFA = [NSMutableString string];
    
    Class identifierClass = (NSClassFromString(@"ASIdentifierManager"));
    if (identifierClass != nil) {
        [arkIDFA setString: [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    }else{
        [arkIDFA setString:[self hashedMAC:YES colons:YES]];
    }
    return arkIDFA;
}

+(NSString*)hashedMAC:(BOOL)uppercase colons:(BOOL)colons
{
    NSString *result = nil;
	NSString *useMac=nil;
	char* macAddressString= (char*)malloc(18);
	NSString *macAddressRaw= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0") encoding:NSMacOSRomanStringEncoding];
    
    if(uppercase && !colons)
    {
		useMac= [[macAddressRaw uppercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    else if ( uppercase && colons )
    {
		useMac= [macAddressRaw uppercaseString];
    }
    else if ( !uppercase && !colons )
    {
		useMac= [[macAddressRaw lowercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    else if ( !uppercase && colons )
    {
		useMac= [macAddressRaw lowercaseString];
    }
	free(macAddressString);
	macAddressString = NULL;
    
    if(useMac) {
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        NSData *data = [useMac dataUsingEncoding:NSASCIIStringEncoding];
        CC_MD5([data bytes], [data length], digest);
        result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1],
				  digest[2], digest[3],
				  digest[4], digest[5],
				  digest[6], digest[7],
				  digest[8], digest[9],
				  digest[10], digest[11],
				  digest[12], digest[13],
				  digest[14], digest[15]];
        result = [result uppercaseString];
    }
    return result;
}

+(NSString*)sha1MAC:(BOOL)uppercase colons:(BOOL)colons
{
    NSString *result = nil;
	NSString *useMac=nil;
	char* macAddressString= (char*)malloc(18);
	NSString *macAddressRaw= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0") encoding:NSMacOSRomanStringEncoding];
    if(uppercase && !colons)
    {
		useMac= [[macAddressRaw uppercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    else if ( uppercase && colons )
    {
		useMac= [macAddressRaw uppercaseString];
    }
    else if ( !uppercase && !colons )
    {
		useMac= [[macAddressRaw lowercaseString] stringByReplacingOccurrencesOfString:@":" withString:@""];
    }
    else if ( !uppercase && colons )
    {
		useMac= [macAddressRaw lowercaseString];
    }
	free(macAddressString);
	macAddressString = NULL;
    
    if(useMac) {
        unsigned char digest[CC_SHA1_DIGEST_LENGTH];
        NSData *data = [useMac dataUsingEncoding:NSASCIIStringEncoding];
        CC_SHA1([data bytes], [data length], digest);
        result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1],
				  digest[2], digest[3],
				  digest[4], digest[5],
				  digest[6], digest[7],
				  digest[8], digest[9],
				  digest[10], digest[11],
				  digest[12], digest[13],
				  digest[14], digest[15],
				  digest[16], digest[17],
				  digest[18], digest[19]
                  ];
        result = [result uppercaseString];
    }
    return result;
}

+(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = ServerDomain;
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(NSString*)hashedValue:(NSString *)value uppercase:(BOOL)uppercase
{
    NSString *result = nil;
    if(value)
    {
        unsigned char digest[16];
        NSData *data = [value dataUsingEncoding:NSASCIIStringEncoding];
        CC_MD5([data bytes], [data length], digest);
        result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				  digest[0], digest[1],
				  digest[2], digest[3],
				  digest[4], digest[5],
				  digest[6], digest[7],
				  digest[8], digest[9],
				  digest[10], digest[11],
				  digest[12], digest[13],
				  digest[14], digest[15]];
        
        if (uppercase)
        {
            result = [result uppercaseString];
        }
    }
    return result;
}

+(NSString*)base64EncodedString:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
    NSInteger i;
    for (i=0; i < length; i += 3)
    {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++)
        {
            value <<= 8;
			
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	NSString *base64Str = @"";
    return [base64Str initWithData:data encoding:NSASCIIStringEncoding];
}

+(NSString*)encryptedMAC
{
    NSData *dataToEncrypt = [[self rawMacAddress] dataUsingEncoding:NSUTF8StringEncoding];
    return [self base64EncodedString:dataToEncrypt];
}

+(NSString*)get_log_i
{
    return [NSString stringWithFormat:@"%ueaa%ua2e2e0%ua%ufca6", 41134, 447, 6674, 504881];
}

@end
