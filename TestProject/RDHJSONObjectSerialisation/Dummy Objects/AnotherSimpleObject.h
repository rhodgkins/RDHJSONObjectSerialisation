//
//  AnotherSimpleObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDHJSONObjectSerialisationProtocol.h"

#import "SubSimpleObject.h"

typedef struct simpleStruct {
    int tttt;
} SimpleStruct;

@interface AnotherSimpleObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, readonly) NSDecimalNumber *decimalProperty;

@property (nonatomic, assign) dispatch_block_t blockProperty;
@property (nonatomic, assign) int* intPointerProperty;
@property (nonatomic, assign) NSObject *const*const objectArrayProperty;
@property (nonatomic, assign) NSString * (*functionPointerDefault)(Class);
@property (nonatomic, assign) void *voidPointerDefault;
@property (nonatomic, assign) SimpleStruct structProperty;

@property (nonatomic, assign) bool cppBoolProperty;
@property (nonatomic, assign) _Bool c99BoolProperty;

@property (nonatomic, assign) Class classProperty;

+(instancetype)objectWithValue:(id)value;

@end

