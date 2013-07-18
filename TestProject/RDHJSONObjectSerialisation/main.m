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
    NSLog(@"%@ -> %@", [SimpleObject class], [RDHJSONObjectSerialisation dictionaryForObject:[SimpleObject new] options:0]);
    NSLog(@"%@ -> %@", [ExtendedSimpleObject class], [RDHJSONObjectSerialisation dictionaryForObject:[ExtendedSimpleObject new] options:0]);
    
    NSLog(@"%@ -> %@", [SimpleObject class], [RDHJSONObjectSerialisation dictionaryForObject:[SimpleObject new] options:RDHJSONWritingOptionsConvertNilsToNSNulls]);
    NSLog(@"%@ -> %@", [ExtendedSimpleObject class], [RDHJSONObjectSerialisation dictionaryForObject:[ExtendedSimpleObject new] options:RDHJSONWritingOptionsConvertNilsToNSNulls]);
    
}












