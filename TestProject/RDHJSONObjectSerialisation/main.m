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
    NSLog(@"%@ -> %@", [AnotherSimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[AnotherSimpleObject new] options:0 error:nil] encoding:NSUTF8StringEncoding]);
    
    return;
    NSLog(@"%@ -> %@", [SimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[SimpleObject new] options:0 error:nil] encoding:NSUTF8StringEncoding]);
    NSLog(@"%@ -> %@", [ExtendedSimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[ExtendedSimpleObject new] options:0 error:nil] encoding:NSUTF8StringEncoding]);
    
    NSLog(@"%@ -> %@", [SimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[SimpleObject new] options:RDHJSONWritingOptionsConvertNilsToNSNulls error:nil] encoding:NSUTF8StringEncoding]);
    NSLog(@"%@ -> %@", [ExtendedSimpleObject class], [[NSString alloc] initWithData:[RDHJSONObjectSerialisation JSONForObject:[ExtendedSimpleObject new] options:RDHJSONWritingOptionsConvertNilsToNSNulls error:nil] encoding:NSUTF8StringEncoding]);
 
    NSLog(@"%@ -> %@", S, [RDHJSONObjectSerialisation objectOfKind:[ExtendedSimpleObject class] forJSON:[S dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
}












