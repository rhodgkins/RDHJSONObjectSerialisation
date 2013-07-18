//
//  SimpleObject.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "SimpleObject.h"

#import "AnotherSimpleObject.h"

@interface SimpleObject ()

@property (nonatomic, copy) NSString *interfacExtProperty;

@property (nonatomic, copy) NSArray *nilArrayInterfaceExtProperty;

@property (nonatomic, copy) NSArray *arrayInterfaceExtProperty;

@property (nonatomic, copy) NSDictionary *dictInterfaceExtProperty;

@property (nonatomic, copy) NSDictionary *nilDictInterfaceExtProperty;

@property (nonatomic, copy) NSObject *objectInterfaceExtProperty;

@property (nonatomic, copy) NSDictionary *jsonInterfaceExtProperty;

@end

@implementation SimpleObject

+(BOOL)shouldSerialiseProperty:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"interfaceProperty"]) {
        return NO;
    } else {
        return YES;
    }
}

+(NSString *)serialisationNameForProperty:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"interfacExtProperty"]) {
        return @"interface_ext_property";
    } else {
        return nil;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _interfaceProperty = @"INTERFACE_PROPERTY";
        _interfacExtProperty = @"INTERFACE_EXTENSION_PROPERTY";
        
        _arrayInterfaceExtProperty = @[@"OBJECT 1", @2, [NSObject new], [AnotherSimpleObject objectWithValue:@"VAL"]];
        _dictInterfaceExtProperty = @{@"KEY1" : @{@"KEY2" : @"VALUE"}, @"KEY3" : [AnotherSimpleObject objectWithValue:@2], @2 : @"INVALID KEY"};
        _objectInterfaceExtProperty = [NSObject new];
        
        _jsonInterfaceExtProperty = @{@"KEY 1" : @"VALUE 1", @"KEY 2" : @[@"S1", @"S2"], @"KEY 3" : @{@"KEY 4" : @[@"SS1", @"SS2"], @"KEY 5" : @"VALUE 2", @"KEY 6" : @{}}};
    }
    return self;
}

@end
