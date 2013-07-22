//
//  RDHUtils.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDHUtils : NSObject

+(NSDateFormatter *)ISO8601DateFormatter;

+(NSString *)stringForDecimalNumber:(NSDecimalNumber *)number;

+(NSDecimalNumber *)decimalNumberForString:(NSString *)string;

+(NSNumber *)numberForString:(NSString *)string;

+(NSData *)dataFromBase64String:(NSString *)encoding;

+(NSString *)base64StringFromData:(NSData *)data;

@end
