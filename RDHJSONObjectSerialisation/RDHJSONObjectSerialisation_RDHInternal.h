//
//  RDHJSONObjectSerialisation_RDHInternal.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 21/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation.h"

#import <objc/runtime.h>

#import "RDHPropertyInfo.h"

#import "RDHJSONObjectSerialisationProtocol.h"

@interface RDHJSONObjectSerialisation ()

@property (nonatomic, copy) NSMutableDictionary *classPropertyCache;

-(NSOrderedSet *)propertiesForClass:(Class)cls;

+(BOOL)isValidJSONPrimative:(id)value;

+(BOOL)isValidJSONPrimativeClass:(Class)cls;

+(BOOL)conformsToSerialisationProtocol:(id)value;

+(NSString *)stringForDecimalNumber:(NSDecimalNumber *)number;

+(NSDecimalNumber *)decimalNumberForString:(NSString *)string;

@end
