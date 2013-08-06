//
//  TestObject.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 04/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject

+(NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *df;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [NSDateFormatter new];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"yyyy-MM-dd"];
    });
    return df;
}

+(Class)classForObjectsInArrayProperty:(NSString *)propertyName
{
    if ([@"arrayStringProp" isEqualToString:propertyName]) {
        return [NSString class];
    } else if ([@"arrayNumberProp" isEqualToString:propertyName]) {
        return [NSNumber class];
    }
    return nil;
}

+(id)serialisationValueForValue:(id)value forProperty:(NSString *)propertyName
{
    if ([@"customDateProp" isEqualToString:propertyName]) {
        return [[self dateFormatter] stringFromDate:value];
    }
    return value;
}

+(id)deserialisationValueForValue:(id)value forProperty:(NSString *)propertyName
{
    if ([@"customDateProp" isEqualToString:propertyName]) {
        return [[self dateFormatter] dateFromString:value];
    }
    return value;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _strProp = @"STR_PROP";
        _decNumProp = [NSDecimalNumber decimalNumberWithString:@"23434234.2342342343232432"];
        _numProp = @(2324.003);
        
        _shortProp = -133;
        _intProp  = -2343;
        _longProp = -234324324234324L;
        
        _boolPropYES = YES;
        _boolPropNO = NO;
        
        _arrayStringProp = @[@"A1", @"A2", @"A3"];
        _arrayNumberProp = @[@1, @2, @3, @4];
                
        _dataProp = [@"BASE 64 ENCODED STRING" dataUsingEncoding:NSUTF8StringEncoding];
        
        _dateProp = [NSDate dateWithTimeIntervalSince1970:2342342342];
        
        _customDateProp = [NSDate dateWithTimeIntervalSince1970:1143534664];
        
        _objectProp = [AnotherTestObject new];
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

-(BOOL)isEqual:(id)object
{
    if ([super isEqual:object]) {
        return YES;
    }
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    typeof(self) o = object;
    
    if (self.decNumProp != o.decNumProp && ![self.decNumProp isEqualToNumber:o.decNumProp]) {
        return NO;
    }
    if (self.numProp != o.numProp && ![self.numProp isEqualToNumber:o.numProp]) {
        return NO;
    }
    if (self.strProp != o.strProp && ![self.strProp isEqualToString:o.strProp]) {
        return NO;
    }
    if (self.shortProp != o.shortProp) {
        return NO;
    }
    if (self.intProp != o.intProp) {
        return NO;
    }
    if (self.longProp != o.longProp) {
        return NO;
    }
    if (self.boolPropYES != o.boolPropYES) {
        return NO;
    }
    if (self.boolPropNO != o.boolPropNO) {
        return NO;
    }
    if (self.arrayStringProp != o.arrayStringProp && ![self.arrayStringProp isEqualToArray:o.arrayStringProp]) {
        return NO;
    }
    if (self.arrayNumberProp != o.arrayNumberProp && ![self.arrayNumberProp isEqualToArray:o.arrayNumberProp]) {
        return NO;
    }
    if (self.objectProp != o.objectProp && ![self.objectProp isEqual:o.objectProp]) {
        return NO;
    }
    if (self.dateProp != o.dateProp && ![self.dateProp isEqualToDate:o.dateProp]) {
        return NO;
    }
    if (self.dataProp != o.dataProp && ![self.dataProp isEqualToData:o.dataProp]) {
        return NO;
    }
    if (self.customDateProp != o.customDateProp && ![[[[self class] dateFormatter] stringFromDate:self.customDateProp] isEqualToString:[[[self class] dateFormatter] stringFromDate:o.customDateProp]]) {
        return NO;
    }
    if (self.nilStringProp != o.nilStringProp && ![self.nilStringProp isEqualToString:o.nilStringProp]) {
        return NO;
    }
    
    return YES;
}

@end

@implementation AnotherTestObject

-(instancetype)init
{
    self = [super init];
    if (self) {
        _anotherStrProp = @"INNER_PROP";
        _anotherDecNumProp = [NSDecimalNumber decimalNumberWithString:@"486768768.876488867867"];
        _anotherNumProp = @(3547.0);
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

-(BOOL)isEqual:(id)object
{
    if ([super isEqual:object]) {
        return YES;
    }
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    typeof(self) o = object;
    
    if (self.anotherDecNumProp != o.anotherDecNumProp && ![self.anotherDecNumProp isEqualToNumber:o.anotherDecNumProp]) {
        return NO;
    }
    if (self.anotherNumProp != o.anotherNumProp && ![self.anotherNumProp isEqualToNumber:o.anotherNumProp]) {
        return NO;
    }
    if (self.anotherStrProp != o.anotherStrProp && ![self.anotherStrProp isEqualToString:o.anotherStrProp]) {
        return NO;
    }
    
    return YES;
}

@end
