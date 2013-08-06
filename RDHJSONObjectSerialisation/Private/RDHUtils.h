//
//  RDHUtils.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface RDHUtils : NSObject

+(NSLocale *)enUSPOSIXLocale;

+(NSDateFormatter *)ISO8601DateFormatter;

+(NSString *)stringForDecimalNumber:(NSDecimalNumber *)number;

+(NSDecimalNumber *)decimalNumberForString:(NSString *)string;

+(NSNumber *)numberForString:(NSString *)string;

+(NSData *)dataFromBase64String:(NSString *)encoding;

+(NSString *)base64StringFromData:(NSData *)data;

@end
