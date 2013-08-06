//
//  RDHJSONObjectSerialisationTests.m
//  RDHJSONObjectSerialisationTests
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "SenTestCase+RDHJSON.h"

@interface RDHTestObjectTests : SenTestCase

@end

#import "TestObject.h"

static NSString *const JSON_OUTPUT_NO_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n  \"boolPropNO\" : 0,\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"shortProp\" : -133,\n  \"boolPropYES\" : 1,\n  \"numProp\" : \"2324.003\",\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"decNumProp\" : \"23434234.2342342343232432\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ]\n}";

static NSString *const JSON_OUTPUT_NIL_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"nilStringProp\" : null,\n  \"boolPropNO\" : 0,\n  \"boolPropYES\" : 1,\n  \"shortProp\" : -133,\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"numProp\" : \"2324.003\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ],\n  \"decNumProp\" : \"23434234.2342342343232432\"\n}";

static NSString *const JSON_OUTPUT_UNIX_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : 2342342342,\n  \"boolPropNO\" : 0,\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"shortProp\" : -133,\n  \"boolPropYES\" : 1,\n  \"numProp\" : \"2324.003\",\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"decNumProp\" : \"23434234.2342342343232432\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ]\n}";

static NSString *const JSON_OUTPUT_NIL_UNIX_OPTIONS = @"{\n  \"longProp\" : -234324324234324,\n  \"intProp\" : -2343,\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dateProp\" : 2342342342,\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"nilStringProp\" : null,\n  \"boolPropNO\" : 0,\n  \"boolPropYES\" : 1,\n  \"shortProp\" : -133,\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"numProp\" : \"2324.003\",\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ],\n  \"decNumProp\" : \"23434234.2342342343232432\"\n}";

@implementation RDHTestObjectTests

-(void)testSerialisationNoOptions
{
    TestObject *object = [TestObject new];
    
    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsNoOptions];
    
    [self partialStringTests:json against:JSON_OUTPUT_NO_OPTIONS];
}

-(void)testSerialisationNullOptions
{
    TestObject *object = [TestObject new];
    
    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsConvertNilsToNulls];
    
    [self partialStringTests:json against:JSON_OUTPUT_NIL_OPTIONS];
}

-(void)testSerialisationUnixOptions
{
    TestObject *object = [TestObject new];
    
    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsConvertDatesToUnixTimestamps];
    
    [self partialStringTests:json against:JSON_OUTPUT_UNIX_OPTIONS];
}

-(void)testSerialisationNilUnixOptions
{
    TestObject *object = [TestObject new];
    
    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsConvertDatesToUnixTimestamps | RDHJSONWritingOptionsConvertNilsToNulls];
    
    [self partialStringTests:json against:JSON_OUTPUT_NIL_UNIX_OPTIONS];
}

-(void)testDeserialisationNoOptions
{
    TestObject *object = [self objectOfKind:[TestObject class] forJSONString:JSON_OUTPUT_NO_OPTIONS];
    
    TestObject *o = [TestObject new];
    STAssertEqualObjects(object, o, nil);
}

-(void)testDeserialisationNilOptions
{
    TestObject *object = [self objectOfKind:[TestObject class] forJSONString:JSON_OUTPUT_NIL_OPTIONS];
    
    TestObject *o = [TestObject new];
    STAssertEqualObjects(object, o, nil);
}

-(void)testDeserialisationUnixOptions
{
    TestObject *object = [self objectOfKind:[TestObject class] forJSONString:JSON_OUTPUT_UNIX_OPTIONS];
    
    TestObject *o = [TestObject new];
    STAssertEqualObjects(object, o, nil);
}

-(void)testDeserialisationNilUnixOptions
{
    TestObject *object = [self objectOfKind:[TestObject class] forJSONString:JSON_OUTPUT_NIL_UNIX_OPTIONS];
    
    TestObject *o = [TestObject new];
    STAssertEqualObjects(object, o, nil);
}

@end
