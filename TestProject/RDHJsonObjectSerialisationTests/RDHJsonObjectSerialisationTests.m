//
//  RDHJsonObjectSerialisationTests.m
//  RDHJsonObjectSerialisationTests
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//
#import <SenTestingKit/SenTestingKit.h>

#import "RDHJSONObjectSerialisation.h"

#import "TestObject.h"

static NSString *const JSON_OUTPUT_NO_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n  \"boolPropNO\" : 0,\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"shortProp\" : -133,\n  \"boolPropYES\" : 1,\n  \"numProp\" : \"2324.003\",\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"decNumProp\" : \"23434234.2342342343232432\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ]\n}";

static NSString *const JSON_OUTPUT_NIL_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"nilStringProp\" : null,\n  \"boolPropNO\" : 0,\n  \"boolPropYES\" : 1,\n  \"shortProp\" : -133,\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"numProp\" : \"2324.003\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ],\n  \"decNumProp\" : \"23434234.2342342343232432\"\n}";

static NSString *const JSON_OUTPUT_UNIX_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : 2342342342,\n  \"boolPropNO\" : 0,\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"shortProp\" : -133,\n  \"boolPropYES\" : 1,\n  \"numProp\" : \"2324.003\",\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"decNumProp\" : \"23434234.2342342343232432\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ]\n}";

@interface NSData (UTF8String)

-(NSString *)UTF8String;

@end

@interface NSString (UTF8Data)

-(NSData *)UTF8Data;

@end

@interface RDHJsonObjectSerialisationTests : SenTestCase

@end

@implementation RDHJsonObjectSerialisationTests

-(void)testSerialisationNoOptions
{
    TestObject *object = [TestObject new];
    [object description];
    
    NSError *error;
    NSData *jsonData = [RDHJSONObjectSerialisation JSONForObject:object options:RDHJSONWritingOptionsNoOptions error:&error];
    
    STAssertNotNil(jsonData, @"%@", error);
    
    NSString *json = [jsonData UTF8String];
    
    [self partialStringTests:json against:JSON_OUTPUT_NO_OPTIONS];
}

-(void)testSerialisationNullOptions
{
    TestObject *object = [TestObject new];
    [object description];
    
    NSError *error;
    NSData *jsonData = [RDHJSONObjectSerialisation JSONForObject:object options:RDHJSONWritingOptionsConvertNilsToNSNulls error:&error];
    
    STAssertNotNil(jsonData, @"%@", error);
    
    NSString *json = [jsonData UTF8String];
    
    [self partialStringTests:json against:JSON_OUTPUT_NIL_OPTIONS];
}

-(void)testSerialisationUnixOptions
{
    TestObject *object = [TestObject new];
    [object description];
    
    NSError *error;
    NSData *jsonData = [RDHJSONObjectSerialisation JSONForObject:object options:RDHJSONWritingOptionsConvertDatesToUnixTimestamps error:&error];
    
    STAssertNotNil(jsonData, @"%@", error);
    
    NSString *json = [jsonData UTF8String];
    
    [self partialStringTests:json against:JSON_OUTPUT_UNIX_OPTIONS];
}

-(void)testDeserialisationNoOptions
{
    NSError *error;
    TestObject *object = [RDHJSONObjectSerialisation objectOfKind:[TestObject class] forJSON:[JSON_OUTPUT_NO_OPTIONS UTF8Data] options:RDHJSONReadingOptionsRaiseExceptions error:&error];
    object.tag = @"DESERIALISED";
    
    STAssertNotNil(object, @"%@", error);
    
    TestObject *o = [TestObject new];
    o.tag = @"CREATED";
    STAssertEqualObjects(object, o, nil);//, @"%@ != %@", object, o);
}

-(void)testDeserialisationNilOptions
{
    NSError *error;
    TestObject *object = [RDHJSONObjectSerialisation objectOfKind:[TestObject class] forJSON:[JSON_OUTPUT_NIL_OPTIONS UTF8Data] options:RDHJSONReadingOptionsRaiseExceptions error:&error];
    object.tag = @"DESERIALISED";
    
    STAssertNotNil(object, @"%@", error);
    
    TestObject *o = [TestObject new];
    o.tag = @"CREATED";
    STAssertEqualObjects(object, o, nil);//, @"%@ != %@", object, o);
}

-(void)testDeserialisationUnixOptions
{
    NSError *error;
    TestObject *object = [RDHJSONObjectSerialisation objectOfKind:[TestObject class] forJSON:[JSON_OUTPUT_UNIX_OPTIONS UTF8Data] options:RDHJSONReadingOptionsRaiseExceptions error:&error];
    object.tag = @"DESERIALISED";
    
    STAssertNotNil(object, @"%@", error);
    
    TestObject *o = [TestObject new];
    o.tag = @"CREATED";
    STAssertEqualObjects(object, o, nil);//, @"%@ != %@", object, o);
}

-(void)partialStringTests:(NSString *)test against:(NSString *)against
{
    NSUInteger len = [test length];
    STAssertEquals(len, [against length], @"Lengths are not equal");
    
    NSRange r = NSMakeRange(0, 16);
    while (NSMaxRange(r) < len) {
        
        NSString *t = [test substringWithRange:r];
        NSString *a = [against substringWithRange:r];
        STAssertEqualObjects(t, a, @"Substrings for range %@ are not equal: %@ != %@", NSStringFromRange(r), t, a);
        
        if (NSMaxRange(r) + r.length < len) {
            r.location += r.length;
        } else {
            r.location += len - NSMaxRange(r);
        }
    }
}

@end

@implementation NSData (UTF8String)

-(NSString *)UTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (UTF8Data)

-(NSData *)UTF8Data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end
