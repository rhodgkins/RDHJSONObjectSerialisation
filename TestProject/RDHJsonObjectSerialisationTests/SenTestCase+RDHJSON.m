//
//  SenTestCase+RDHJSON.m
//  RDHJSONObjectSerialisationTests
//
//  Created by Richard Hodgkins on 06/08/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "SenTestCase+RDHJSON.h"

@implementation SenTestCase (RDHJSON)

-(NSString *)JSONstringForObject:(id)object options:(RDHJSONWritingOptions)options
{
    NSError *error;
    NSData *jsonData = [RDHJSONObjectSerialisation JSONForObject:object options:options error:&error];
    
    STAssertNotNil(jsonData, @"%@", error);
    
    return [jsonData UTF8String];
}

-(id)objectOfKind:(Class)cls forJSONString:(NSString *)string
{
    NSError *error;
    id object = [RDHJSONObjectSerialisation objectOfKind:cls forJSON:[string UTF8Data] options:RDHJSONReadingOptionsRaiseExceptions error:&error];
    
    STAssertNotNil(object, @"%@", error);
    
    return object;
}

-(void)partialStringTests:(NSString *)test against:(NSString *)against
{
    NSUInteger len = [test length];
    STAssertEquals(len, [against length], @"Lengths are not equal");
    
    NSRange r = NSMakeRange(0, 10);
    while (NSMaxRange(r) < len) {
        
        NSString *t = [test substringWithRange:r];
        NSString *a = [against substringWithRange:r];
        STAssertEqualObjects(t, a, @"Substrings for range %@ are not equal: %@ != %@", NSStringFromRange(r), t, a);
        
        if (NSMaxRange(r) + r.length < len) {
            r.location += r.length;
        } else {
            r.location += len - NSMaxRange(r);
        }
    }
}

@end

@implementation NSData (UTF8String)

-(NSString *)UTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (UTF8Data)

-(NSData *)UTF8Data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end
