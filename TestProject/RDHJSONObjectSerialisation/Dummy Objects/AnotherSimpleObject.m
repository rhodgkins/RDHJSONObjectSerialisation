//
//  AnotherSimpleObject.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "AnotherSimpleObject.h"

@interface AnotherSimpleObject ()

@property (nonatomic, strong) id valueProperty;

@end

@implementation AnotherSimpleObject

+(instancetype)objectWithValue:(id)value
{
    return [[self alloc] initWithValue:value];
}

-(instancetype)initWithValue:(id)value
{
    self = [self init];
    if (self) {
        _valueProperty = value;
        _decimalProperty = [NSDecimalNumber decimalNumberWithString:@"234e-3"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ [valueProperty=%@, decimalProperty=%@]", [super description], self.valueProperty, self.decimalProperty];
}

-(NSString *)debugDescription
{
    return [self description];
}

@end
