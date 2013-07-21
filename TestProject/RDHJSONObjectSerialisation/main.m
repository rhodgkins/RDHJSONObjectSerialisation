//
//  main.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "RDHJSONObjectSerialisation.h"

#import "SimpleObject.h"
#import "ExtendedSimpleObject.h"
#import "AnotherSimpleObject.h"

static NSString *const S = @"\r\n\r\n{\"jsonInterfaceExtProperty\":{\"KEY 1\":\"VALUE 1\",\"KEY 2\":[\"S1\",\"S2\"],\"KEY 3\":{\"KEY 4\":[\"SS1\",\"SS2\"],\"KEY 5\":\"VALUE 2\",\"KEY 6\":{}}},\"interfacExtPropertySubClass\":\"INTERFACE_EXTENSION_PROPERTY_SUB_CLASS\",\"nanNumberProperty\":{},\"dictInterfaceExtProperty\":{\"KEY1\":{\"KEY2\":\"VALUE\"},\"KEY3\":{\"valueProperty\":2}},\"infinityNumberProperty\":{},\"nilDictInterfaceExtProperty\":null,\"interface_ext_property\":\"INTERFACE_EXTENSION_PROPERTY\",\"nilArrayInterfaceExtProperty\":null,\"protocolExtPropertyObject\":{\"valueProperty\":[\"STRING IN ARRAY\"]},\"boolExtPropertySubClass\":1,\"arrayInterfaceExtProperty\":[\"OBJECT 1\",2,{\"valueProperty\":\"VAL\"}],\"jsonInvalidNumberInterfaceExtProperty\":{},\"interfacPropertySubClass\":\"INTERFACE_PROPERTY_SUB_CLASS\"}\r\n\r\n";

static NSString *const SS = @"{\r\n  \"readOnlyProperty\" : \"READONLY_PROP\",\r\n  \"customAccessorsProperty\" : \"C_A_P\",\r\n  \"cppBoolProperty\" : true,\r\n  \"decimalProperty\" : \"2.340000E-001\",\r\n  \"c99BoolProperty\" : true,\r\n  \"customProperty\" : \"CUSTOM PROPERTY\",\r\n  \"classProperty\" : \"NSNotificationCenter\",\r\n  \"valueProperty\" : \"sdfsdfdsf\", \r\n \"blockProperty\" : \"BLOCK\"\r\n, \r\n \"numberProperty\" : \"2345\"\r\n, \r\n \"intPrimProp\" : \"77456.345E-9\"\r\n}";

static NSString *const SD = @"{\r\n  \"readOnlyProperty\" : \"READONLY_PROP\",\r\n  \"customAccessorsProperty\" : \"C_A_P\",\r\n  \"cppBoolProperty\" : true,\r\n  \"decimalProperty\" : 2.340000E-001,\r\n  \"c99BoolProperty\" : true,\r\n  \"customProperty\" : \"CUSTOM PROPERTY\",\r\n  \"classProperty\" : \"NSNotificationCenter\",\r\n  \"valueProperty\" : \"sdfsdfdsf\"\r\n}";

static void run();
static void propertiesForClass(Class);

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        run();
    }
    return 0;
}

static void run()
{
    SubSimpleObject *o = [SubSimpleObject new];
//    o.objectProp = [SubSimpleObject new];
    o.objectProp.objectProp = [SubSimpleObject new];
    o.objectProp.objectProp.objectProp = [SubSimpleObject new];
    
    o.arrayObjectProp = @[[SubSimpleObject new], [SubSimpleObject new]];
    o.dictObjectProp = @{RDH_KEY_COCOCA : [NSError errorWithDomain:@"DOMAIN" code:0 userInfo:nil],
                         RDH_KEY_CUSTOM : [SubSimpleObject new]};
    NSString *s;
    s = [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:o options:0 error:nil] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@ -> %@", o, s);
    
    s = [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:o options:RDHJSONWritingOptionsConvertNilsToNSNulls error:nil] encoding:NSUTF8StringEncoding];
    NSLog(@"%@ -> %@", o, s);
    
    SubSimpleObject *o2 = [RDHJSONObjectSerialisation objectOfKind:[SubSimpleObject class] forJSON:[s dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSLog(@"%@ -> %@", s, o2);
    
    return;
    NSLog(@"%@ -> %@", [AnotherSimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[AnotherSimpleObject objectWithValue:@"sdfsdfdsf"] options:0 error:nil] encoding:NSUTF8StringEncoding]);
    
    NSLog(@"%@ -> %@", SS, [RDHJSONObjectSerialisation objectOfKind:[AnotherSimpleObject class] forJSON:[SS dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
    
    NSLog(@"%@ -> %@", [SimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[SimpleObject new] options:0 error:nil] encoding:NSUTF8StringEncoding]);
    NSLog(@"%@ -> %@", [ExtendedSimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[ExtendedSimpleObject new] options:0 error:nil] encoding:NSUTF8StringEncoding]);
    
    NSLog(@"%@ -> %@", [SimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[SimpleObject new] options:RDHJSONWritingOptionsConvertNilsToNSNulls error:nil] encoding:NSUTF8StringEncoding]);
    NSLog(@"%@ -> %@", [ExtendedSimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[ExtendedSimpleObject new] options:RDHJSONWritingOptionsConvertNilsToNSNulls error:nil] encoding:NSUTF8StringEncoding]);
 
    NSLog(@"%@ -> %@", S, [RDHJSONObjectSerialisation objectOfKind:[ExtendedSimpleObject class] forJSON:[S dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
}












