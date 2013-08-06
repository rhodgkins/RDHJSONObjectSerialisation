//
//  RDHTestObject2Tests.m
//  RDHJSONObjectSerialisationTests
//
//  Created by Richard Hodgkins on 06/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "SenTestCase+RDHJSON.h"

@interface RDHTestObject2Tests : SenTestCase

@end

#import "TestObject2.h"

static NSString *const JSON_OUTPUT_NO_OPTIONS = @"{\n  \"dictStringProp\" : {\n    \"SK1\" : \"V1\",\n    \"SK2\" : \"V2\"\n  },\n  \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n  \"boolPropYES\" : 1,\n  \"intProp\" : -2343,\n  \"objectPropInSubClass\" : {\n    \"longProp\" : -234324324234324,\n    \"intProp\" : -2343,\n    \"objectProp\" : {\n      \"anotherDecNumProp\" : \"486768768.876488867867\",\n      \"anotherStrProp\" : \"INNER_PROP\",\n      \"anotherNumProp\" : \"3547\"\n    },\n    \"strProp\" : \"STR_PROP\",\n    \"customDateProp\" : \"2006-03-28\",\n    \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n    \"boolPropNO\" : 0,\n    \"arrayStringProp\" : [\n      \"A1\",\n      \"A2\",\n      \"A3\"\n    ],\n    \"shortProp\" : -133,\n    \"boolPropYES\" : 1,\n    \"numProp\" : \"2324.003\",\n    \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n    \"decNumProp\" : \"23434234.2342342343232432\",\n    \"arrayNumberProp\" : [\n      1,\n      2,\n      3,\n      4\n    ]\n  },\n  \"arrayNumberProp\" : [\n    1,\n    2,\n    3,\n    4\n  ],\n  \"dictNumberProp\" : {\n    \"NK1\" : 1,\n    \"NK2\" : 22\n  },\n  \"numProp\" : \"2324.003\",\n  \"strprop_RENAMED\" : \"renamed this property from renamedStrProp to strprop_RENAMED\",\n  \"customDateProp\" : \"2006-03-28\",\n  \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n  \"arrayStringProp\" : [\n    \"A1\",\n    \"A2\",\n    \"A3\"\n  ],\n  \"decNumProp\" : \"23434234.2342342343232432\",\n  \"excludedDeserialisationStrProp\" : \"EXCLUDED FROM DESERIALISATION\",\n  \"shortProp\" : -133,\n  \"longProp\" : -234324324234324,\n  \"dictObjectProp\" : {\n    \"number_key\" : 24973457,\n    \"decimal_number_key\" : -213.431454352393487,\n    \"another_test_object_key\" : {\n      \"anotherDecNumProp\" : \"486768768.876488867867\",\n      \"anotherStrProp\" : \"INNER_PROP\",\n      \"anotherNumProp\" : \"3547\"\n    },\n    \"string_key\" : \"STRING\",\n    \"test_object_key\" : {\n      \"longProp\" : -234324324234324,\n      \"intProp\" : -2343,\n      \"objectProp\" : {\n        \"anotherDecNumProp\" : \"486768768.876488867867\",\n        \"anotherStrProp\" : \"INNER_PROP\",\n        \"anotherNumProp\" : \"3547\"\n      },\n      \"strProp\" : \"STR_PROP\",\n      \"customDateProp\" : \"2006-03-28\",\n      \"dateProp\" : \"2044-03-23T10:39:02+0000\",\n      \"boolPropNO\" : 0,\n      \"arrayStringProp\" : [\n        \"A1\",\n        \"A2\",\n        \"A3\"\n      ],\n      \"shortProp\" : -133,\n      \"boolPropYES\" : 1,\n      \"numProp\" : \"2324.003\",\n      \"dataProp\" : \"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\n      \"decNumProp\" : \"23434234.2342342343232432\",\n      \"arrayNumberProp\" : [\n        1,\n        2,\n        3,\n        4\n      ]\n    }\n  },\n  \"objectProp\" : {\n    \"anotherDecNumProp\" : \"486768768.876488867867\",\n    \"anotherStrProp\" : \"INNER_PROP\",\n    \"anotherNumProp\" : \"3547\"\n  },\n  \"strProp\" : \"STR_PROP\",\n  \"boolPropNO\" : 0\n}";

@implementation RDHTestObject2Tests

-(void)testSerialisationNoOptions
{
    TestObject2 *object = [TestObject2 new];
    
    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsNoOptions];
    
    [self partialStringTests:json against:JSON_OUTPUT_NO_OPTIONS];
}

//-(void)testSerialisationNullOptions
//{
//    TestObject *object = [TestObject new];
//    
//    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsConvertNilsToNulls];
//    
//    [self partialStringTests:json against:JSON_OUTPUT_NIL_OPTIONS];
//}
//
//-(void)testSerialisationUnixOptions
//{
//    TestObject *object = [TestObject new];
//    
//    NSString *json = [self JSONstringForObject:object options:RDHJSONWritingOptionsConvertDatesToUnixTimestamps];
//    
//    [self partialStringTests:json against:JSON_OUTPUT_UNIX_OPTIONS];
//}

-(void)testDeserialisationNoOptions
{
    TestObject2 *object = [self objectOfKind:[TestObject2 class] forJSONString:@"{\"longProp\":-234324324234324,\"dictObjectProp\":{\"number_key\":24973457,\"decimal_number_key\":-213.43146,\"another_test_object_key\":{\"anotherDecNumProp\":\"486768768.876488867867\",\"anotherStrProp\":\"INNER_PROP\",\"anotherNumProp\":\"3547\"},\"string_key\":\"STRING\"},\"intProp\":-2343,\"strprop_RENAMED\":\"renamed this property from renamedStrProp to strprop_RENAMED\",\"objectProp\":{\"anotherDecNumProp\":\"486768768.876488867867\",\"anotherStrProp\":\"INNER_PROP\",\"anotherNumProp\":\"3547\"},\"dictNumberProp\":{\"NK1\":1,\"NK2\":22},\"strProp\":\"STR_PROP\",\"excludedDeserialisationStrProp\":\"EXCLUDED FROM DESERIALISATION\",\"customDateProp\":\"2006-03-28\",\"dateProp\":\"2044-03-23T10:39:02+0000\",\"boolPropNO\":0,\"arrayStringProp\":[\"A1\",\"A2\",\"A3\"],\"shortProp\":-133,\"boolPropYES\":1,\"numProp\":\"2324.003\",\"dataProp\":\"QkFTRSA2NCBFTkNPREVEIFNUUklORw==\",\"decNumProp\":\"23434234.2342342343232432\",\"arrayNumberProp\":[1,2,3,4],\"dictStringProp\":{\"SK1\":\"V1\",\"SK2\":\"V2\"}}"];
    
    TestObject2 *o = [TestObject2 new];
    STAssertEqualObjects(object, o, nil);
}

@end
