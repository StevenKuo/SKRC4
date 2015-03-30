//
//  SKRC4.h
//  SKRC4
//
//  Created by steven on 2015/3/24.
//  Copyright (c) 2015年 KKBOX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKRC4 : NSObject

+ (NSString *)RC4EncryptionWithKey:(NSString *)key string:(NSString *)string;
+ (NSString *)RC4DecryptionWithKey:(NSString *)key string:(NSString *)string;

+ (NSString *)hexStringFromString:(NSString *)string;
+ (NSString *)stringFromHexString:(NSString *)string;
@end
