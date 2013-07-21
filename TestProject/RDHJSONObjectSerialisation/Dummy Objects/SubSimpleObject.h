//
//  SubSimpleObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDHJSONObjectSerialisationProtocol.h"

@interface SubSimpleObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, strong) NSString *strProp;
@property (nonatomic, strong) NSDecimalNumber *decNumProp;
@property (nonatomic, strong) NSNumber *numProp;

@property (nonatomic) char charProp;
@property (nonatomic) short shortProp;
@property (nonatomic) int intProp;
@property (nonatomic) long longProp;
@property (nonatomic) long long longlongProp;
@property (nonatomic) unsigned char ucharProp;
@property (nonatomic) ushort ushortProp;
@property (nonatomic) uint uintProp;
@property (nonatomic) unsigned long ulongProp;
@property (nonatomic) unsigned long long ulonglongProp;

@property (nonatomic) BOOL boolPropYES;
@property (nonatomic) BOOL boolPropNO;

@property (nonatomic, strong) NSArray *arrayStringProp;
@property (nonatomic, strong) NSArray *arrayNumberProp;

@property (nonatomic, strong) NSDictionary *dictStringProp;
@property (nonatomic, strong) NSDictionary *dictNumberProp;
@property (nonatomic, strong) NSDictionary *dictMixedProp;

@property (nonatomic, strong) SubSimpleObject *objectProp;

@end
