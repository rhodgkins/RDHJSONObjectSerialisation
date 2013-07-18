//
//  RDHJSONObjectSerialisation.m
//  RDHJSONObjectSerialisation
//
//  Created by Richard Hodgkins on 18/07/2013.
//  Copyright (c) 2013 Rich H. All rights reserved.
//

#import "RDHJSONObjectSerialisation.h"

#import <objc/runtime.h>

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define IS_OBJECT(T) _Generic( (T), id: YES, default: NO)

@interface RDHJSONObjectSerialisation ()

@end

@implementation RDHJSONObjectSerialisation

+(NSSet *)propertiesForClass:(Class)cls
{
    NSMutableSet *properties = [NSMutableSet set];
    
    do {
        uint32_t outCount;
        objc_property_t *ps = class_copyPropertyList(cls, &outCount);
        
        for (NSUInteger i=0; i<outCount; i++) {
            objc_property_t p = ps[i];
            
            const char *propertyName = property_getName(p);
            
            [properties addObject:[NSString stringWithUTF8String:propertyName]];
        }
        
        cls = [cls superclass];
        
    } while (cls && ![[NSObject class] isKindOfClass:cls]);
    
    return [properties copy];
}

+(NSDictionary *)dictionaryForObject:(NSObject<RDHJSONObjectSerialisationProtocol> *)object options:(RDHJSONWritingOptions)options
{
    if (!object) {
        return nil;
    }
    NSAssert([self canSerialiseToJSON:object] || [NSJSONSerialization isValidJSONObject:object], @"Object is not able to be serialised: %@", object);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSSet *properties = [self propertiesForClass:[object class]];
    
    Class cls = [object class];
    const BOOL hasShouldSerialiseProperty = [cls respondsToSelector:@selector(shouldSerialiseProperty:)];
    const BOOL hasSerialisationNameForProperty = [cls respondsToSelector:@selector(serialisationNameForProperty:)];
    
    for (NSString *property in properties) {
        
        if (!hasShouldSerialiseProperty || [cls shouldSerialiseProperty:property]) {
            
            NSString *key = nil;
            if (hasSerialisationNameForProperty) {
                key = [cls serialisationNameForProperty:property];
            }
            if (!key) {
                key = property;
            }
            
            id value = [object valueForKey:property];
            
            [dict setValue:[self JSONForObject:value options:options] forKey:key];
            
//            NSLog(@"(%@) %@ : %@ -> %@ (%d)", property, [value class], value, dict[key], [self isValidJSONPrimative:value]);
        }
    }
    
    return dict;
}

+(id)JSONForObject:(id)value options:(RDHJSONWritingOptions)options
{
    if (value) {
        if ([NSJSONSerialization isValidJSONObject:value]) {
            return value;
            
        } else if ([self isValidJSONPrimative:value]) {
            return value;
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            return [self JSONForArray:value options:options];
            
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            return [self JSONForDictionary:value options:options];
            
        } else if ([self canSerialiseToJSON:value]) {
            return [self dictionaryForObject:value options:options];
        }
        
    } else {
        if (options & RDHJSONWritingOptionsConvertNilsToNSNulls) {
            return [NSNull null];
        }
    }
    
    return nil;
}

+(NSArray *)JSONForArray:(NSArray *)array options:(RDHJSONWritingOptions)options
{
    NSMutableArray *json = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (id a in array) {
        id v = [self JSONForObject:a options:options];
        if (v) {
            // Can only store valid JSON objects
            [json addObject:v];
        }
    }
    
    return json;
}

+(NSDictionary *)JSONForDictionary:(NSDictionary *)dict options:(RDHJSONWritingOptions)options
{
    NSMutableDictionary *json = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        if ([key isKindOfClass:[NSString class]]) {
            // Can only use string keys
            id v = [self JSONForObject:obj options:options];
            if (v) {
                json[key] = v;
            }
        }
    }];
    
    return json;
}

+(BOOL)isValidJSONPrimative:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return YES;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        
        // Don't allow NaN or Inifity as per JSON spec
        if ([@(INFINITY) isEqualToNumber:value]) {
            return NO;
        } else if ([@(NAN) isEqualToNumber:value]) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

+(BOOL)canSerialiseToJSON:(id)value
{
    return [value conformsToProtocol:@protocol(RDHJSONObjectSerialisationProtocol)];
}

@end
