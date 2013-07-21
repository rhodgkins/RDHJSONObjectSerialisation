//
//  AnotherSimpleObject.h
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RDHJSONObjectSerialisationProtocol.h"

typedef struct simpleStruct {
    int x;
} SimpleStruct;

@interface AnotherSimpleObject : NSObject<RDHJSONObjectSerialisationProtocol>

@property (nonatomic, readonly) NSDecimalNumber *decimalProperty;

@property (nonatomic, assign) dispatch_block_t blockProperty;
@property (nonatomic, assign) int* intPointerProperty;
@property (nonatomic, assign) NSObject *const*const objectArrayProperty;
@property (nonatomic, assign) int (*functionPointerDefault)(char *);
@property (nonatomic, assign) void *voidPointerDefault;
@property (nonatomic, assign) SimpleStruct structProperty;

@property (nonatomic, assign) bool cppBoolProperty;
@property (nonatomic, assign) _Bool c99BoolProperty;

+(instancetype)objectWithValue:(id)value;

@end

