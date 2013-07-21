//
//  ExtendedSimpleObject.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "ExtendedSimpleObject.h"

#import "AnotherSimpleObject.h"

@interface ExtendedSimpleObject ()

@property (nonatomic, copy) NSString *interfacExtPropertySubClass;

@property (nonatomic, assign, getter = isBoolExtPropertySubClass) BOOL boolExtPropertySubClass;

@property (nonatomic, strong) AnotherSimpleObject *protocolExtPropertyObject;

@end

@implementation ExtendedSimpleObject

- (id)init
{
    self = [super init];
    if (self) {
        _interfacPropertySubClass = @"INTERFACE_PROPERTY_SUB_CLASS";
        _interfacExtPropertySubClass = @"INTERFACE_EXTENSION_PROPERTY_SUB_CLASS";
        _boolExtPropertySubClass = YES;
        _protocolExtPropertyObject = [AnotherSimpleObject objectWithValue:@[@"STRING IN ARRAY"]];
    }
    return self;
}

@end
