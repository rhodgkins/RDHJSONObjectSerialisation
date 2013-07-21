//
//  RDHUtils.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDHUtils : NSObject

+(NSString *)stringForDecimalNumber:(NSDecimalNumber *)number;

+(NSDecimalNumber *)decimalNumberForString:(NSString *)string;

+(NSNumber *)numberForString:(NSString *)string;

@end
