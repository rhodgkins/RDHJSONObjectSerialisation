//
//  SubSimpleObject.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "SubSimpleObject.h"

#import <objc/runtime.h>

@implementation SubSimpleObject

+(Class)classForObjectsInArrayProperty:(NSString *)property
{
    if ([@"arrayStringProp" isEqualToString:property]) {
        return [NSString class];
    } else if ([@"arrayNumberProp" isEqualToString:property]) {
        return [NSNumber class];
    } else if ([@"arrayObjectProp" isEqualToString:property]) {
        return self;
    }
    return nil;
}

+(Class)classForObjectWithKey:(NSString *)key forDictionaryProperty:(NSString *)property
{
    if ([@"dictStringProp" isEqualToString:property]) {
        return [NSString class];
    } else if ([@"dictNumberProp" isEqualToString:property]) {
        return [NSNumber class];
    } else if ([@"dictMixedProp" isEqualToString:property]) {
        if ([@"NUM" isEqualToString:key]) {
            return [NSNumber class];
        } else if ([@"STR" isEqualToString:key]) {
            return [NSString class];
        }
    } else if ([@"dictObjectProp" isEqualToString:property]) {
        if ([RDH_KEY_COCOCA isEqualToString:key]) {
            return [NSNotification class];
        } else if ([RDH_KEY_CUSTOM isEqualToString:key]) {
            return self;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _strProp = @"STR_PROP";
        _decNumProp = [NSDecimalNumber decimalNumberWithString:@"23434234.2342342343232432"];
        _numProp = @(2324.003f);
        
        _charProp = 't';
        _shortProp = -133;
        _intProp  = -2343;
        _longProp = -234324324234324L;
        _longlongProp = -(3242342394234324324LL);
        _ucharProp = 'u';
        _ushortProp = 23423;
        _uintProp = 3324234234;
        _ulongProp = (3423423423423434234UL);
        _ulonglongProp = (3242343243243242342ULL);
        
        _boolPropYES = YES;
        _boolPropNO = NO;
        
        _arrayStringProp = @[@"A1", @"A2", @"A3"];
        _arrayNumberProp = @[@1, @2, @3, @4];
        
        _dictStringProp = @{@"K1" : @"V1",
                            @"K2" : @"V2"
                            };
        _dictNumberProp = @{@"K1" : @1,
                            @"K2" : @2
                            };
        _dictMixedProp = @{@"NUM" : @1,
                            @"STR" : @"V2"
                            };
        
        _cocoaObjectProp = [NSNotification notificationWithName:@"DUMMY" object:nil];
    }
    return self;
}

-(NSString *)description
{
    unsigned int count;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *props = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (NSUInteger i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(list[i])];
        
        id v = [self valueForKey:name];
        if (!v) {
            v = @"NULL";
        }
        [props setValue:v forKey:name];
    }
    
    return [props debugDescription];
}

@end
