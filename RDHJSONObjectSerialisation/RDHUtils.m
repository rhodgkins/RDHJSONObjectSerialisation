//
//  RDHUtils.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHUtils.h"

@implementation RDHUtils

+(NSString *)stringForDecimalNumber:(NSNumber *)number
{
    if (number) {
        return [[self decimalNumberFormatter] stringFromNumber:number];
    } else {
        return nil;
    }
}

+(NSDecimalNumber *)decimalNumberForString:(NSString *)string
{
    if (string) {
        return (NSDecimalNumber *) [[self decimalNumberFormatter] numberFromString:string];
    } else {
        return nil;
    }
}

+(NSNumber *)numberForString:(NSString *)string
{
    if (string) {
        return [[self numberFormatter] numberFromString:string];
    } else {
        return nil;
    }
}

+(NSNumberFormatter *)decimalNumberFormatter
{
    static NSNumberFormatter *decimalNumberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        decimalNumberFormatter = [NSNumberFormatter new];
        [decimalNumberFormatter setLocale:[self enUSPOSIXLocale]];
        [decimalNumberFormatter setLenient:YES];
        [decimalNumberFormatter setGeneratesDecimalNumbers:YES];
        [decimalNumberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    });
    return decimalNumberFormatter;
}

+(NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *numberFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        [numberFormatter setLocale:[self enUSPOSIXLocale]];
        [numberFormatter setLenient:YES];
        [numberFormatter setGeneratesDecimalNumbers:NO];
        [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    });
    return numberFormatter;
}

+(NSLocale *)enUSPOSIXLocale
{
    static NSLocale *enUSPOSIXLocale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        NSAssert(enUSPOSIXLocale, @"Cannot setup locale for en_US_POSIX");
    });
    return enUSPOSIXLocale;
}

@end
