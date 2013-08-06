//
//  TestObject2.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "TestObject2.h"

#import <objc/runtime.h>

@implementation TestObject2

+(BOOL)shouldDeserialiseProperty:(NSString *)propertyName
{
    if ([@"excludedBothStrProp" isEqualToString:propertyName]) {
        return NO;
    } else if ([@"excludedDeserialisationStrProp" isEqualToString:propertyName]) {
        return NO;
    } else {
        return YES;
    }
}

+(BOOL)shouldSerialiseProperty:(NSString *)propertyName
{
    if ([@"excludedBothStrProp" isEqualToString:propertyName]) {
        return NO;
    } else if ([@"excludedSerialisationStrProp" isEqualToString:propertyName]) {
       return NO;
    } else {
        return YES;
    }
}

+(NSString *)serialisationNameForProperty:(NSString *)propertyName
{
    if ([@"renamedStrProp" isEqualToString:propertyName]) {
        return [[[propertyName substringFromIndex:NSMaxRange([propertyName rangeOfString:@"renamed"])] lowercaseString] stringByAppendingString:@"_RENAMED"];
    } else {
        return propertyName;
    }
}

+(Class)classForObjectWithKey:(NSString *)key forDictionaryProperty:(NSString *)property
{
    if ([@"dictObjectProp" isEqualToString:property]) {
        if ([@"string_key" isEqualToString:key]) {
            return [NSString class];
        } else if ([@"number_key" isEqualToString:key]) {
            return [NSNumber class];
        } else if ([@"decimal_number_key" isEqualToString:key]) {
            return [NSDecimalNumber class];
        } else if ([@"test_object_key" isEqualToString:key]) {
            return [TestObject class];
        } else if ([@"another_test_object_key" isEqualToString:key]) {
            return [AnotherTestObject class];
        }
    }
    return nil;
}

+(instancetype)newObjectForDeserialisation
{
    TestObject2 *o = [self new];
    o.excludedBothStrProp = nil;
    o.excludedDeserialisationStrProp = nil;
    o.excludedSerialisationStrProp = nil;
    
    return o;
}

- (id)init
{
    self = [super init];
    if (self) {
        _excludedBothStrProp = @"EXCLUDED FROM BOTH";
        
        _excludedDeserialisationStrProp = @"EXCLUDED FROM DESERIALISATION";
        
        _excludedSerialisationStrProp = @"EXCLUDED FROM SERIALISATION";
        
        _renamedStrProp = @"renamed this property from renamedStrProp to strprop_RENAMED";
        
        _dictObjectProp = @{@"string_key" : @"STRING",
                            @"number_key" : @(24973457.000000001),
                            @"decimal_number_key" : [NSDecimalNumber decimalNumberWithMantissa:213431454352393487 exponent:-15 isNegative:YES],
//                            @"test_object_key" : [TestObject new],
                            @"another_test_object_key" : [AnotherTestObject new]
                            };
        
        _dictStringProp = @{@"SK1" : @"V1",
                            @"SK2" : @"V2"
                            };
        _dictNumberProp = @{@"NK1" : @1,
                            @"NK2" : @22,
                            @"NK2" : @333
                            };
        
//        _objectPropInSubClass = [TestObject new];
    }
    return self;
}

-(NSUInteger)hash
{
    return [self autoHash];
}

-(NSString *)description
{
    return [self autoDescription];
}

@end
