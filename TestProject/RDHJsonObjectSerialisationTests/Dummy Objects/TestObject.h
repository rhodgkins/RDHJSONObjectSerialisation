//
//  TestObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 04/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDHJSONObjectSerialisationProtocol.h"

@class AnotherTestObject;
@interface TestObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, strong) NSString *strProp;
@property (nonatomic, strong) NSDecimalNumber *decNumProp;
@property (nonatomic, strong) NSNumber *numProp;

@property (nonatomic) short shortProp;
@property (nonatomic) int intProp;
@property (nonatomic) long longProp;

@property (nonatomic) BOOL boolPropYES;
@property (nonatomic) BOOL boolPropNO;

@property (nonatomic, strong) NSArray *arrayStringProp;
@property (nonatomic, strong) NSArray *arrayNumberProp;

@property (nonatomic, strong) AnotherTestObject *objectProp;

@property (nonatomic, strong) NSDate *dateProp;

@property (nonatomic, strong) NSData *dataProp;

@property (nonatomic, strong) NSDate *customDateProp;

@property (nonatomic, strong) NSString *nilStringProp;

@end

@interface AnotherTestObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, strong) NSString *anotherStrProp;
@property (nonatomic, strong) NSDecimalNumber *anotherDecNumProp;
@property (nonatomic, strong) NSNumber *anotherNumProp;

@end