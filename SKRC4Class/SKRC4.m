//
//  SKRC4.m
//  SKRC4
//
//  Created by steven on 2015/3/24.
//  Copyright (c) 2015年 KKBOX. All rights reserved.
//

#import "SKRC4.h"

@implementation SKRC4

+ (NSString *)RC4EncryptionWithKey:(NSString *)key string:(NSString *)string
{
	NSUInteger initValue = 0;
	
	NSMutableArray *sBOX = [NSMutableArray array];
	for (NSUInteger index = 0; index < 256; index++) {
		[sBOX addObject:[NSNumber numberWithInteger:index]];
	}
	for (NSUInteger index = 0; index < 256; index++) {
		initValue = (initValue + [sBOX[index] integerValue] + [key characterAtIndex:(index % [key length])]) % 256;
		NSNumber *temp = sBOX[index];
		sBOX[index] = sBOX[initValue];
		sBOX[initValue] = temp;
	}
	
	NSString *result = @"";
	
	NSUInteger firstPointer = 0;
	NSUInteger secondePointer = 0;

	const char *utf8 = [string UTF8String];
	
	for (NSUInteger index = 0; index < strlen(utf8); index ++) {
		firstPointer = (firstPointer + 1) % 256;
		secondePointer = (secondePointer + [sBOX[firstPointer] integerValue]) % 256;
		NSNumber *temp = sBOX[firstPointer];
		sBOX[firstPointer] = sBOX[secondePointer];
		sBOX[secondePointer] = temp;
		
		NSUInteger v = [sBOX[(([sBOX[firstPointer] integerValue] + [sBOX[secondePointer] integerValue]) % 256)] integerValue];
		NSUInteger s = [[NSNumber numberWithUnsignedChar:utf8[index]] integerValue];
		result = [result stringByAppendingFormat:@"%c", s^v];
	}
	return result;
}

+ (NSString *)hexStringFromString:(NSString *)string
{
	NSString *result = @"";
	for (NSUInteger index = 0; index < [string length]; index ++) {
		unichar s = [string characterAtIndex:index];
		result = [result stringByAppendingString:[NSString stringWithFormat:@"%.2x", s]];
	}
	return result;
}

+ (NSString *)stringFromHexString:(NSString *)string
{
	NSString *result = @"";
	for (NSUInteger index = 0; index < [string length]; index += 2) {
		NSString *hex = [string substringWithRange:NSMakeRange(index, 2)];
		NSScanner *scanner = [NSScanner scannerWithString:hex];
		unsigned int scannerInt;
		if (![scanner scanHexInt:&scannerInt]) {
			return @"";
		}
		result = [result stringByAppendingString:[NSString stringWithFormat:@"%c",scannerInt]];
	}
	return result;
}

+ (NSString *)RC4DecryptionWithKey:(NSString *)key string:(NSString *)string
{
	NSUInteger initValue = 0;
	
	NSMutableArray *sBOX = [NSMutableArray array];
	for (NSUInteger index = 0; index < 256; index++) {
		[sBOX addObject:[NSNumber numberWithInteger:index]];
	}
	for (NSUInteger index = 0; index < 256; index++) {
		initValue = (initValue + [sBOX[index] integerValue] + [key characterAtIndex:(index % [key length])]) % 256;
		NSNumber *temp = sBOX[index];
		sBOX[index] = sBOX[initValue];
		sBOX[initValue] = temp;
	}
	
	
	NSUInteger firstPointer = 0;
	NSUInteger secondePointer = 0;

	NSMutableData *hexDec = [NSMutableData data];
	
	for (NSUInteger index = 0; index < [string length]; index ++) {
		firstPointer = (firstPointer + 1) % 256;
		secondePointer = (secondePointer + [sBOX[firstPointer] integerValue]) % 256;
		NSNumber *temp = sBOX[firstPointer];
		sBOX[firstPointer] = sBOX[secondePointer];
		sBOX[secondePointer] = temp;
		
		unichar unidec = [string characterAtIndex:index];
		NSUInteger v = [sBOX[(([sBOX[firstPointer] integerValue] + [sBOX[secondePointer] integerValue]) % 256)] integerValue];
		NSUInteger s = unidec;
		const char boldOnBytes[] = {s^v};
		[hexDec appendBytes:boldOnBytes length:sizeof(boldOnBytes)];
	}
	
	NSString *result = [[NSString alloc] initWithData:hexDec encoding:NSUTF8StringEncoding];
	return result;
}

@end
